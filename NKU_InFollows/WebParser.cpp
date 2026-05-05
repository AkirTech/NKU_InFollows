#include <QCoreApplication>
#include <QTimer>
#include <QThread>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QNetworkCookie>
#include <QUrl>
#include <QDebug>
#include <QEventLoop> 
#include <QByteArray>
#include <QObject>
#include <QMessageBox>
#include <QString>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDateTime>
#include <QFile>
#include <QTextStream>
#include <QFileInfo>
#include <QRegularExpression>
#include <string>
#include <QProcess>
#include "WebParser.h"


WebParser::WebParser(QObject* parent, cfgLoader* cfg) : QObject(parent), config(cfg), m_isLogin(false), m_backendProcess(nullptr)
{
    manager = new QNetworkAccessManager(this);
    m_checkTimer = new QTimer(this);
    connect(m_checkTimer, &QTimer::timeout, this, &WebParser::checkLoginStatus);
    connect(manager, &QNetworkAccessManager::finished,
        this, &WebParser::onFinished);
}

WebParser::~WebParser() {
    stopBackendService();
}

void WebParser::stopBackendService() {
    if (m_backendProcess) {
        qDebug() << "Stopping backend service...";
        m_backendProcess->terminate();
        if (m_backendProcess->waitForFinished(3000)) {
            qDebug() << "Backend service stopped successfully";
        } else {
            qDebug() << "Backend service did not stop in time, killing...";
            m_backendProcess->kill();
            m_backendProcess->waitForFinished(1000);
        }
        delete m_backendProcess;
        m_backendProcess = nullptr;
    }
    
    qDebug() << "Terminating python.exe processes...";
    QProcess::execute("taskkill", QStringList() << "/F" << "/IM" << "python.exe");
    QThread::msleep(500);
}

void WebParser::fetchUrl(const QUrl& _url) {
    QNetworkRequest request(_url);
    manager->get(request);
}

QString WebParser::postAIRq(const QString &model ,const QString &u_msg,
    const QString &s_msg,QUrl &baseUrl){
    QJsonObject rqBody;
    rqBody["model"] = model;
    rqBody["stream"] = false;

    QJsonArray messages;
    
    if (!s_msg.isEmpty()) {
        QJsonObject sysMsg;
        sysMsg["role"] = "system";
        sysMsg["content"] = s_msg;
        messages.append(sysMsg);
    }

    QJsonObject userMsg;
    userMsg["role"] = "user";
    userMsg["content"] = u_msg;
    messages.append(userMsg);

    rqBody["messages"] = messages;
        
    QJsonDocument doc(rqBody);
    QByteArray jsonData = doc.toJson();

    QNetworkRequest rq(baseUrl);
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    QNetworkAccessManager localManager;
    QNetworkReply* reply = localManager.post(rq, jsonData);
    
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    
    QString res;
    if (reply->error() == QNetworkReply::NoError) {
        res = reply->readAll();
    } else {
        qDebug() << "Error in postAIRq:" << reply->errorString();
        res = "{\"error\":\"" + reply->errorString() + "\"}";
    }
    
    reply->deleteLater();
    return res;
}

QString WebParser::postAIRq(const QString &model ,const QString &sys_prompt,
        QUrl &baseUrl){
    QJsonObject rqBody;
    rqBody["model"] = model;
    rqBody["stream"] = false;
        
    QJsonArray messages;
    QJsonObject sysp;
    sysp["role"] = "system";
    sysp["content"] = sys_prompt;
    messages.append(sysp);

    rqBody["messages"] = messages;
    QJsonDocument doc(rqBody);
    QByteArray jsonData = doc.toJson();

    QNetworkRequest rq(baseUrl);
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        
    QNetworkAccessManager localManager;
    QNetworkReply* reply = localManager.post(rq, jsonData);
    
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    
    QString res;
    if (reply->error() == QNetworkReply::NoError) {
        res = reply->readAll();
    } else {
        qDebug() << "Error in postAIRq:" << reply->errorString();
        res = "{\"error\":\"" + reply->errorString() + "\"}";
    }
    
    reply->deleteLater();
    return res;

}

void WebParser::startSync() {
    QMetaObject::invokeMethod(this, [this]() {
        QString baseUrl = "http://localhost:8001";
        QString access = config->get("mp.access_token");
        
        QString collectLimitStr = config->get("mp.collect_limit");
        int collectLimit = collectLimitStr.isEmpty() ? 6 : collectLimitStr.toInt();
        if (collectLimit <= 0) {
            collectLimit = 6;
        }
        
        emit syncProgressUpdated("开始同步...", 0);
        
        // 步骤1：获取文章
        emit syncProgressUpdated("正在获取文章列表...", 20);
        QString recmdResult = getMPRecmd(baseUrl, access, collectLimit);
        
        if (recmdResult.startsWith("NEED_LOGIN")) {
            emit syncError("需要先登录微信公众平台");
            return;
        }
        
        if (recmdResult.startsWith("ERROR")) {
            emit syncError("获取文章失败：" + recmdResult);
            return;
        }
        
        emit syncProgressUpdated("文章列表获取成功", 50);
        
        // 步骤2：AI推荐
        emit syncProgressUpdated("正在进行AI推荐分析...", 60);
        QString aiResult = getAIAnalysis();
        
        if (aiResult.startsWith("ERROR")) {
            emit syncError("AI推荐失败：" + aiResult);
            return;
        }
        
        emit syncProgressUpdated("同步完成", 100);
        emit syncCompleted(aiResult);
    }, Qt::QueuedConnection);
}

QJsonObject WebParser::getMPSearchRq(const QString &search, const QUrl &Url, const QString access) {
    QString urlStr = Url.toString();
    
    qDebug() << "Original URL:" << urlStr;
    qDebug() << "Search term:" << search;
    
    if (urlStr.contains("wxmps")) {
        urlStr = urlStr.replace("wxmps", "wx/mps");
    }
    
    // Append search term as path parameter
    if (!urlStr.endsWith("/")) {
        urlStr += "/";
    }
    urlStr += search.toUtf8().toPercentEncoding();
    
    QUrl requestUrl(urlStr);
    
    QUrlQuery query;
    query.addQueryItem("offset", "0");
    query.addQueryItem("limit", "5");
    requestUrl.setQuery(query);
    
    qDebug() << "Search URL:" << requestUrl.toString();
    qDebug() << "Access token:" << access;
    
    QNetworkAccessManager localmanager;

    QNetworkRequest rq(requestUrl);
    rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
    rq.setRawHeader("accept", "application/json");
    
    QNetworkReply* reply = localmanager.get(rq);
    
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    
    QJsonObject result;
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Search response data:" << data;
        
        if (data.isEmpty() || data == "null" || data == "\"null\"") {
            qDebug() << "Empty or null response";
        } else {
            QJsonDocument res = QJsonDocument::fromJson(data);
            if (!res.isNull() && res.isObject()) {
                QJsonObject dataObj = res.object().value("data").toObject();
                if (!dataObj.isEmpty()) {
                    QJsonArray list = dataObj.value("list").toArray();
                    result = list.isEmpty() ? QJsonObject() : list.first().toObject();
                } else {
                    qDebug() << "Data object is empty";
                }
            } else {
                qDebug() << "Error parsing JSON response";
            }
        }
    } else {
        qDebug() << "Error in getMPSearchRq:" << reply->errorString();
        if (reply->errorString().contains("Connection refused")) {
            qDebug() << "Backend not running, attempting to start...";
            startBackendService();
        }
    }
    
    reply->deleteLater();
    return result;

}

QJsonObject WebParser::getMPSearchRq(const QString& search, const QString& Url, const QString access) {
    return getMPSearchRq(search, QUrl(Url), access);
}

QString WebParser::we_login(const QUrl Url, const QString& username, const QString& password) {
    
	QString c_token = config->get("mp.access_token");
    if (c_token != "") {
		qDebug() << "Already have token, skipping mp backend login.";
    }
    
    QNetworkRequest rq(Url);
    rq.setRawHeader("accept", "application/json");
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QByteArray postData;
    postData.append("grant_type=password&");
    postData.append("username=").append(QUrl::toPercentEncoding(username)).append("&");
    postData.append("password=").append(QUrl::toPercentEncoding(password)).append("&");
    postData.append("scope=&client_id=&client_secret=");

    QNetworkAccessManager localManager;
    QNetworkReply* reply = localManager.post(rq, postData);

    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();

    QJsonObject result;
    QString token;
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Response data:" << data;
        QJsonDocument res = QJsonDocument::fromJson(data);
        if (!res.isNull() && res.isObject()) {
            token = res.object().value("access_token").toString();
            if (!token.isEmpty()) {
                if (config) {
                    config->set("mp.access_token", token);
                }
                qDebug() << "Login successful, token:" << token ;
            } else {
                qDebug() << "Error: access_token not found in response";
            }
        }
        else {
            qDebug() << "Error parsing JSON response";
        }
    }
    else {
        qDebug() << "Error in we_login:" << reply->errorString();
        if (reply->errorString().contains("Connection refused")) {
            qDebug() << "Backend not running, attempting to start...";
            startBackendService();
        }
    }

    reply->deleteLater();
    return token;
}


QString WebParser::onFinished(QNetworkReply* reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Data:" << data;
    } else {
        qDebug() << "Error:" << reply->errorString();
    }
    
    reply->deleteLater();
    return reply->error() == QNetworkReply::NoError ? "OK" : "Error";
}

QString WebParser::wxLoginGetQR(const QString &Url,const QString access) {
	QNetworkAccessManager localManager;
    
    QNetworkRequest rq(Url+ "/api/v1/wx/auth/qr/code");
    rq.setRawHeader("accept", "application/json");
    rq.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
    QNetworkReply* testReply = localManager.get(rq);
    QEventLoop testLoop;
    connect(testReply, &QNetworkReply::finished, &testLoop, &QEventLoop::quit);
    testLoop.exec();
    
    if (testReply->error() != QNetworkReply::NoError) {
        qDebug() << "Backend connection test failed:" << testReply->errorString();
        if (testReply->errorString().contains("Connection refused")) {
            qDebug() << "Backend not running, attempting to start...";
            startBackendService();
        }
    }
    testReply->deleteLater();
    
    // 第一步：获取二维码
	rq.setUrl(QUrl(Url+ "/api/v1/wx/auth/qr/code"));
	rq.setRawHeader("accept", "application/json");
	rq.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
    QNetworkReply* reply =  localManager.get(rq);
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
	loop.exec();
    
    // 第二步：等待二维码生成完成，最多尝试30次，每次间隔2秒
    int max_attempts = 30;
    bool qr_ready = false;
    
    for (int i = 0; i < max_attempts; i++) {
        QNetworkRequest rq2(Url+"/api/v1/wx/auth/qr/image");
        rq2.setRawHeader("accept", "application/json");
        rq2.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
        QNetworkReply* reply2 =  localManager.get(rq2);
        QEventLoop loop2;
        connect(reply2, &QNetworkReply::finished, &loop2, &QEventLoop::quit);
        loop2.exec();
        
        QJsonObject qr_status = QJsonDocument::fromJson(reply2->readAll()).object();
        
        if (qr_status["data"].toBool() == true) {
            qr_ready = true;
            qDebug() << "QR code generated successfully!";
            break;
        }
        
        qDebug() << "Waiting for QR code to generate, attempt" << (i+1) << "/" << max_attempts;
        QThread::msleep(2000);
    }
    
    if (qr_ready) {
        try
        {
            system("copy //backend/we-mp-rss/static/wx_qrcode.png //wx_qrcode.png");
        }
        catch (const std::exception& e) {
            qDebug() << "Error copying QR code image: " << e.what() << ". Please check if the file exists and try again.";
        }
        qDebug() << "Generated QR OK!";
        return "生成成功";
    }
    else {
        qDebug() << "QR code generation timed out!";
        return "生成失败";
    }
}

QString WebParser::getLoginStatus(const QString &Url, const QString access) {
	QNetworkAccessManager localManager;

    QNetworkRequest rq(Url);
    rq.setRawHeader("accept", "application/json");
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    rq.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
	
	QNetworkReply* reply =  localManager.get(rq);

    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
	loop.exec();

	QString login_status = "waiting";
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Response data:" << data;
        QJsonDocument res = QJsonDocument::fromJson(data);
        if (!res.isNull() && res.isObject()) {
			QJsonObject returndata = res.object().value("data").toObject();
            if (returndata.value("login_status").isBool()) {
                if (returndata.value("login_status").toBool()) {
                    login_status = "success";
                } else {
                    login_status = "waiting";
                }
            } else {
                login_status = returndata.value("login_status").toString();
            }
            qDebug() << "Login status:" << login_status;
        } else {
            qDebug() << "Error parsing JSON response";
        }
    } else {
        qDebug() << "Error in getLoginStatus:" << reply->errorString();
	}

    return login_status;
}

void WebParser::updateWxExpireTime() {
	int currentTime = QDateTime::currentSecsSinceEpoch();
	int newExpireTime = currentTime + 4 * 24 * 60 * 60;
    config->set("mp.expire", QString::number(newExpireTime));
    return;
}

QString WebParser::checkRSSWxStatus(const QString &access) {
	//利用一个固定的URL来检查微信登录状态，返回结果中包含message字段，值为"success"表示登录成功，否则表示登录失败
    QUrl Url = QUrl("http://localhost:8001/api/v1/wx/mps/update/MP_WXS_2397804841");

	QNetworkAccessManager localManager;
    QNetworkRequest rq(Url);
    rq.setRawHeader("accept", "application/json");
	rq.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());

    QNetworkReply* reply =  localManager.get(rq);
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Response data:" << data;
        QJsonDocument res = QJsonDocument::fromJson(data);
        if (!res.isNull() && res.isObject()) {
            bool returndata = (res.object().value("message").toString() == "success");
            qDebug() << "RSS Wx status:" << returndata;
            return returndata ? "成功" : "失败";
        } else {
            qDebug() << "Error parsing JSON response";
            return "解析错误";
        }
    } else {
        qDebug() << "Error in checkRSSWxStatus:" << reply->errorString();
        return "请求错误";
	}
}


void WebParser::wxLoginCheckLoop(const QString &Url, const QString access) {
    m_checkUrl = Url + "/api/v1/wx/auth/qr/status";
    m_accessToken = access;
    m_isLogin = false;
    m_checkTimer->stop();
    checkLoginStatus();
}

void WebParser::checkLoginStatus() {
    QString status = getLoginStatus(m_checkUrl, m_accessToken);
    qDebug() << "Login check status:" << status;
    
    if (status == "success") {
        m_isLogin = true;
        updateWxExpireTime();
        m_checkTimer->stop();
        emit loginSuccess();
    } else {
        m_checkTimer->start(2000);
    }
}

bool WebParser::checkCurrentWxLogin() {
	int expireTime = config->get("mp.expire").toInt();
	int currentTime = QDateTime::currentSecsSinceEpoch();
	return currentTime < expireTime;
}

QString WebParser::getWxExpireTime() {
    int expireTime = config->get("mp.expire").toInt();
    QDateTime expireDateTime = QDateTime::fromSecsSinceEpoch(expireTime);
    return expireDateTime.toString(Qt::ISODate);
}

static QByteArray jsonToByteArray(const QJsonObject& json) {
    QJsonDocument doc(json);
    return doc.toJson();
}

bool WebParser::startBackendService() {
    qDebug() << "Starting backend service...";
    
    QString appDir = QCoreApplication::applicationDirPath();
    QString backendBat = appDir + "/backend_invoker.bat";
    
    qDebug() << "Backend invoker path:" << backendBat;
    
    m_backendProcess = new QProcess();
    m_backendProcess->setWorkingDirectory(appDir);
    m_backendProcess->start(backendBat);
    
    if (m_backendProcess->waitForStarted(5000)) {
        qDebug() << "Backend service started successfully";
        QThread::sleep(3);
        return true;
    } else {
        qDebug() << "Failed to start backend service:" << m_backendProcess->errorString();
        return false;
    }
}

QString WebParser::getMPRefresh(const QString& Url, const QString access) {
    qDebug() << "Starting MP refresh process...";
    qDebug() << "Base URL:" << Url;
    qDebug() << "Access token:" << access;
    
    QString appDir = QCoreApplication::applicationDirPath();
    QString bizsPath = appDir + "/bizs.json";
    
    QFileInfo fileInfo(bizsPath);
    if (!fileInfo.exists()) {
        qDebug() << "bizs.json not found at:" << bizsPath;
        return "ERROR: bizs.json not found";
    }
    
    QFile file(bizsPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open bizs.json";
        return "ERROR: Failed to open bizs.json";
    }
    
    QTextStream stream(&file);
    QString jsonContent = stream.readAll();
    file.close();
    
    QJsonDocument doc = QJsonDocument::fromJson(jsonContent.toUtf8());
    if (doc.isNull() || !doc.isObject()) {
        qDebug() << "Failed to parse bizs.json";
        return "ERROR: Failed to parse bizs.json";
    }
    
    QJsonObject bizsObj = doc.object();
    QStringList mpIds;
    for (const QString& key : bizsObj.keys()) {
        mpIds.append(bizsObj.value(key).toString());
    }
    
    if (mpIds.isEmpty()) {
        qDebug() << "No mp_ids found in bizs.json";
        return "ERROR: No mp_ids found";
    }
    
    qDebug() << "Found" << mpIds.size() << "mp_ids to update";
    
    QString baseUrl = Url;
    if (baseUrl.endsWith("/")) {
        baseUrl = baseUrl.left(baseUrl.length() - 1);
    }
    
    bool needLogin = false;
    
    if (mpIds.isEmpty()) {
        qDebug() << "No mp_ids found, skipping update requests";
    } else {
        QString mpId = mpIds.first();
        qDebug() << "Sending initial update request for mp_id:" << mpId;
        
        QString updateUrlStr = baseUrl + "/api/v1/wx/mps/update/" + mpId;
        QUrl updateUrl(updateUrlStr);
        
        QUrlQuery query;
        query.addQueryItem("start_page", "0");
        query.addQueryItem("end_page", "1");
        updateUrl.setQuery(query);
        
        qDebug() << "Update URL:" << updateUrl.toString();
        
        QNetworkAccessManager localManager;
        QNetworkRequest rq(updateUrl);
        rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
        rq.setRawHeader("accept", "application/json");
        
        QNetworkReply* reply = localManager.get(rq);
        
        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            qDebug() << "Initial update response:" << responseData;
        } else {
            qDebug() << "Initial update request error:" << reply->errorString();
        }
        reply->deleteLater();
        
        qDebug() << "Waiting 6 seconds before checking login status...";
        QThread::sleep(6);
        
        QString statusUrlStr = baseUrl + "/api/v1/wx/auth/qr/status";
        QUrl statusUrl(statusUrlStr);
        
        qDebug() << "Checking login status at:" << statusUrlStr;
        
        QNetworkAccessManager statusManager;
        QNetworkRequest statusReq(statusUrl);
        statusReq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
        statusReq.setRawHeader("accept", "application/json");
        
        QNetworkReply* statusReply = statusManager.get(statusReq);
        
        QEventLoop statusLoop;
        connect(statusReply, &QNetworkReply::finished, &statusLoop, &QEventLoop::quit);
        statusLoop.exec();
        
        if (statusReply->error() == QNetworkReply::NoError) {
            QByteArray statusData = statusReply->readAll();
            qDebug() << "Login status response:" << statusData;
            
            QJsonDocument statusDoc = QJsonDocument::fromJson(statusData);
            if (!statusDoc.isNull() && statusDoc.isObject()) {
                QJsonObject statusObj = statusDoc.object();
                QJsonObject dataObj = statusObj.value("data").toObject();
                
                bool loginStatus = dataObj.value("login_status").toBool();
                bool qrCode = dataObj.value("qr_code").toBool();
                
                qDebug() << "login_status:" << loginStatus << ", qr_code:" << qrCode;
                
                if (!loginStatus && qrCode) {
                    qDebug() << "User not logged in, QR code generated. Please scan QR code first.";
                    needLogin = true;
                }
            }
        } else {
            qDebug() << "Error checking login status:" << statusReply->errorString();
        }
        statusReply->deleteLater();
    }
    
    if (needLogin) {
        return "NEED_LOGIN: Please scan the QR code on the finish page first, then try again.";
    }
    
    qDebug() << "Login confirmed, proceeding with all updates...";
    
    for (int i = 0; i < mpIds.size(); i++) {
        QString mpId = mpIds[i];
        qDebug() << "Updating mp_id:" << mpId << "(" << (i + 1) << "/" << mpIds.size() << ")";
        
        QString updateUrlStr = baseUrl + "/api/v1/wx/mps/update/" + mpId;
        QUrl updateUrl(updateUrlStr);
        
        QUrlQuery query;
        query.addQueryItem("start_page", "0");
        query.addQueryItem("end_page", "1");
        updateUrl.setQuery(query);
        
        QNetworkAccessManager updateManager;
        QNetworkRequest rq(updateUrl);
        rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
        rq.setRawHeader("accept", "application/json");
        
        QNetworkReply* reply = updateManager.get(rq);
        
        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            qDebug() << "Update response for" << mpId << ":" << responseData;
        } else {
            qDebug() << "Error updating mp_id" << mpId << ":" << reply->errorString();
        }
        
        reply->deleteLater();
    }
    
    return "SUCCESS: All mp articles updated";
}

QString WebParser::getMPRecmd(const QString& Url, const QString access, int limit) {
    qDebug() << "Starting MP recommendation fetch...";
    qDebug() << "Base URL:" << Url;
    qDebug() << "Access token:" << access;
    qDebug() << "Fetch limit:" << limit;
    
    QString refreshResult = getMPRefresh(Url, access);
    qDebug() << "getMPRefresh result:" << refreshResult;
    
    if (refreshResult.startsWith("NEED_LOGIN")) {
        qDebug() << "Login required, stopping getMPRecmd";
        return "NEED_LOGIN: " + refreshResult;
    }
    
    QString appDir = QCoreApplication::applicationDirPath();
    QString bizsPath = appDir + "/bizs.json";
    
    QFileInfo fileInfo(bizsPath);
    if (!fileInfo.exists()) {
        qDebug() << "bizs.json not found at:" << bizsPath;
        return "ERROR: bizs.json not found";
    }
    
    QFile bizsFile(bizsPath);
    if (!bizsFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open bizs.json";
        return "ERROR: Failed to open bizs.json";
    }
    
    QTextStream stream(&bizsFile);
    QString jsonContent = stream.readAll();
    bizsFile.close();
    
    QJsonDocument doc = QJsonDocument::fromJson(jsonContent.toUtf8());
    if (doc.isNull() || !doc.isObject()) {
        qDebug() << "Failed to parse bizs.json";
        return "ERROR: Failed to parse bizs.json";
    }
    
    QJsonObject bizsObj = doc.object();
    QStringList mpIds;
    for (const QString& key : bizsObj.keys()) {
        mpIds.append(bizsObj.value(key).toString());
    }
    
    if (mpIds.isEmpty()) {
        qDebug() << "No mp_ids found in bizs.json";
        return "ERROR: No mp_ids found";
    }
    
    qDebug() << "Found" << mpIds.size() << "mp_ids to fetch articles";
    
    QString baseUrl = Url;
    if (baseUrl.endsWith("/")) {
        baseUrl = baseUrl.left(baseUrl.length() - 1);
    }
    
    QJsonArray allArticles;
    
    for (int i = 0; i < mpIds.size(); i++) {
        QString mpId = mpIds[i];
        qDebug() << "Fetching articles for mp_id:" << mpId << "(" << (i + 1) << "/" << mpIds.size() << ")";
        
        QString articlesUrlStr = baseUrl + "/api/v1/wx/articles";
        QUrl articlesUrl(articlesUrlStr);
        
        QUrlQuery query;
        query.addQueryItem("offset", "0");
        query.addQueryItem("limit", QString::number(limit));
        query.addQueryItem("mp_id", mpId);
        query.addQueryItem("only_favorite", "false");
        query.addQueryItem("has_content", "false");
        articlesUrl.setQuery(query);
        
        qDebug() << "Articles URL:" << articlesUrl.toString();
        
        QNetworkAccessManager localManager;
        QNetworkRequest rq(articlesUrl);
        rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
        rq.setRawHeader("accept", "application/json");
        
        QNetworkReply* reply = localManager.get(rq);
        
        QEventLoop loop;
        connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
        loop.exec();
        
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            qDebug() << "Articles response for" << mpId << ":" << responseData.left(500);
            
            QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);
            if (!responseDoc.isNull() && responseDoc.isObject()) {
                QJsonObject responseObj = responseDoc.object();
                QJsonObject dataObj = responseObj.value("data").toObject();
                QJsonArray list = dataObj.value("list").toArray();
                
                for (int j = 0; j < list.size(); j++) {
                    QJsonObject article = list[j].toObject();
                    
                    QJsonObject simplifiedArticle;
                    simplifiedArticle["id"] = allArticles.size();
                    simplifiedArticle["mp_id"] = article.value("mp_id");
                    simplifiedArticle["url"] = article.value("url");
                    simplifiedArticle["title"] = article.value("title");
                    simplifiedArticle["description"] = article.value("description");
                    
                    allArticles.append(simplifiedArticle);
                }
                
                qDebug() << "Added" << list.size() << "articles from" << mpId;
            }
        } else {
            qDebug() << "Error fetching articles for" << mpId << ":" << reply->errorString();
        }
        
        reply->deleteLater();
    }
    
    QString articlesFilePath = appDir + "/articles.json";
    QFile articlesFile(articlesFilePath);
    if (articlesFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&articlesFile);
        QJsonDocument saveDoc(allArticles);
        out << saveDoc.toJson(QJsonDocument::Indented);
        articlesFile.close();
        qDebug() << "Saved" << allArticles.size() << "articles to" << articlesFilePath;
    } else {
        qDebug() << "Failed to save articles to" << articlesFilePath;
        return "ERROR: Failed to save articles";
    }
    
    return "SUCCESS: Fetched and saved" + QString::number(allArticles.size()) + " articles";
}

QString WebParser::getAIAnalysis() {
    qDebug() << "Starting AI analysis...";
    
    QString appDir = QCoreApplication::applicationDirPath();
    
    QString interestsPath = appDir + "/u_interests.json";
    QFile interestsFile(interestsPath);
    if (!interestsFile.exists()) {
        qDebug() << "u_interests.json not found at:" << interestsPath;
        return "ERROR: u_interests.json not found";
    }
    
    if (!interestsFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open u_interests.json";
        return "ERROR: Failed to open u_interests.json";
    }
    
    QTextStream stream(&interestsFile);
    QString interestsContent = stream.readAll();
    interestsFile.close();
    
    QJsonDocument interestsDoc = QJsonDocument::fromJson(interestsContent.toUtf8());
    if (interestsDoc.isNull() || !interestsDoc.isArray()) {
        qDebug() << "Failed to parse u_interests.json";
        return "ERROR: Failed to parse u_interests.json";
    }
    
    QJsonArray interestsArray = interestsDoc.array();
    QString interestsStr = "User interests: ";
    for (int i = 0; i < interestsArray.size(); i++) {
        interestsStr += interestsArray[i].toString();
        if (i < interestsArray.size() - 1) {
            interestsStr += ", ";
        }
    }
    qDebug() << "Interests:" << interestsStr;
    
    QString articlesPath = appDir + "/articles.json";
    QFile articlesFile(articlesPath);
    if (!articlesFile.exists()) {
        qDebug() << "articles.json not found at:" << articlesPath;
        return "ERROR: articles.json not found";
    }
    
    if (!articlesFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open articles.json";
        return "ERROR: Failed to open articles.json";
    }
    
    QTextStream articlesStream(&articlesFile);
    QString articlesContent = articlesStream.readAll();
    articlesFile.close();
    
    QJsonDocument articlesDoc = QJsonDocument::fromJson(articlesContent.toUtf8());
    if (articlesDoc.isNull() || !articlesDoc.isArray()) {
        qDebug() << "Failed to parse articles.json";
        return "ERROR: Failed to parse articles.json";
    }
    
    QJsonArray articlesArray = articlesDoc.array();
    QString articlesStr = "Articles:\n";
    for (int i = 0; i < articlesArray.size(); i++) {
        QJsonObject article = articlesArray[i].toObject();
        QString id = QString::number(i);
        QString title = article.value("title").toString();
        QString description = article.value("description").toString();
        
        articlesStr += QString("%1. %2 - %3\n").arg(id).arg(title).arg(description);
    }
    qDebug() << "Articles string length:" << articlesStr.length();
    
    QString systemPrompt = R"(
You are a professional recommendation assistant. Your role is to analyze user interests and recommend the most relevant articles from the provided list.

## Rules:
1. You must output ONLY a valid JSON array of NUMBERS (article IDs)
2. The JSON format must be: [id1, id2, id3, id4, id5]
3. You must recommend exactly 5 articles by their ID numbers
4. Do NOT output any explanations, comments, or additional text
5. Choose articles that best match the user's interests
6. Output ONLY the JSON array, nothing else
)";
    
    QString userPrompt = QString(R"(
## User Interests:
%1

## Available Articles (format: ID. Title - Description):
%2

## Task:
Please recommend TOP 5 articles that best match the user's interests. Output ONLY a valid JSON array of article IDs:
[0, 1, 7, 3, 6]
)").arg(interestsStr).arg(articlesStr);
    
    QString model = "deepseek-r1:1.5b";
    QString aiUrl = config->get("ai.url");
    if (aiUrl.isEmpty()) {
        aiUrl = "http://localhost:11434/v1";
    }
    
    qDebug() << "AI URL:" << aiUrl;
    QUrl baseUrl(aiUrl + "/chat/completions");
    
    qDebug() << "Calling AI with system prompt and user prompt";
    QString aiResponse = postAIRq(model, userPrompt, systemPrompt, baseUrl);
    
    qDebug() << "AI response:" << aiResponse;
    
    QJsonDocument responseDoc = QJsonDocument::fromJson(aiResponse.toUtf8());
    QJsonArray idArray;
    
    auto extractIdArray = [](QString content) -> QJsonArray {
        QJsonArray arr;
        content = content.trimmed();
        
        if (content.startsWith("```")) {
            int firstNewline = content.indexOf("\n");
            if (firstNewline != -1) {
                content = content.mid(firstNewline + 1);
            }
        }
        
        if (content.endsWith("```")) {
            content = content.left(content.length() - 3);
        }
        
        content = content.trimmed();
        
        if (content.startsWith("```json")) {
            content = content.mid(6).trimmed();
        }
        if (content.startsWith("```")) {
            content = content.mid(3).trimmed();
        }
        if (content.endsWith("```")) {
            content = content.left(content.length() - 3).trimmed();
        }
        
        content = content.trimmed();
        
        QJsonDocument doc = QJsonDocument::fromJson(content.toUtf8());
        if (!doc.isNull() && doc.isArray()) {
            return doc.array();
        }
        
        if (content.startsWith("[")) {
            int endBracket = content.lastIndexOf("]");
            if (endBracket != -1) {
                QString innerContent = content.mid(1, endBracket - 1).trimmed();
                QStringList ids = innerContent.split(",");
                for (QString id : ids) {
                    id = id.trimmed();
                    bool ok;
                    int num = id.toInt(&ok);
                    if (ok) {
                        arr.append(num);
                    }
                }
            }
        }
        
        return arr;
    };
    
    if (responseDoc.isNull()) {
        qDebug() << "Failed to parse AI response as JSON directly";
        QJsonDocument tempDoc = QJsonDocument::fromJson(aiResponse.toUtf8());
        if (!tempDoc.isNull() && tempDoc.isObject()) {
            QJsonObject tempObj = tempDoc.object();
            if (tempObj.contains("choices") && tempObj["choices"].isArray()) {
                QJsonArray choices = tempObj["choices"].toArray();
                if (choices.size() > 0) {
                    QJsonObject firstChoice = choices[0].toObject();
                    if (firstChoice.contains("message") && firstChoice["message"].isObject()) {
                        QJsonObject message = firstChoice["message"].toObject();
                        if (message.contains("content")) {
                            QString content = message["content"].toString();
                            qDebug() << "Extracted content:" << content.left(500);
                            idArray = extractIdArray(content);
                        }
                    }
                }
            }
        }
    } else if (responseDoc.isArray()) {
        idArray = responseDoc.array();
    } else if (responseDoc.isObject()) {
        QJsonObject responseObj = responseDoc.object();
        if (responseObj.contains("choices") && responseObj["choices"].isArray()) {
            QJsonArray choices = responseObj["choices"].toArray();
            if (choices.size() > 0) {
                QJsonObject firstChoice = choices[0].toObject();
                if (firstChoice.contains("message") && firstChoice["message"].isObject()) {
                    QJsonObject message = firstChoice["message"].toObject();
                    if (message.contains("content")) {
                        QString content = message["content"].toString();
                        qDebug() << "Extracted content:" << content.left(500);
                        idArray = extractIdArray(content);
                    }
                }
            }
        }
    }
    
    if (idArray.isEmpty()) {
        qDebug() << "Failed to extract article IDs from AI response";
        return "ERROR: Failed to parse AI response";
    }
    
    QJsonArray resultArray;
    for (int i = 0; i < idArray.size(); i++) {
        int articleId = idArray[i].toInt();
        if (articleId >= 0 && articleId < articlesArray.size()) {
            QJsonObject article = articlesArray[articleId].toObject();
            QJsonObject resultItem;
            resultItem["title"] = article.value("title").toString();
            resultItem["url"] = article.value("url").toString();
            resultArray.append(resultItem);
        }
    }
    
    if (resultArray.isEmpty()) {
        qDebug() << "No valid articles found for the recommended IDs";
        return "ERROR: No valid articles found";
    }
    
    QString timestamp = QString::number(QDateTime::currentDateTime().toSecsSinceEpoch());
    QString outputPath = appDir + "/recommend_" + timestamp + ".json";
    
    QFile outputFile(outputPath);
    if (outputFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&outputFile);
        QJsonDocument saveDoc(resultArray);
        out << saveDoc.toJson(QJsonDocument::Indented);
        outputFile.close();
        qDebug() << "Saved recommendations to" << outputPath;
        return "SUCCESS: Recommendations saved to " + outputPath;
    } else {
        qDebug() << "Failed to save recommendations";
        return "ERROR: Failed to save recommendations";
    }
}

QString WebParser::addMP(const QString& Url, const QString access, const QString& mpName, const QString& mpCover, const QString& mpId, const QString& mpIntro) {
    qDebug() << "Adding MP:" << mpName << "with id:" << mpId;
    
    QString baseUrl = Url;
    if (baseUrl.endsWith("/")) {
        baseUrl = baseUrl.left(baseUrl.length() - 1);
    }
    
    QString apiUrl = baseUrl + "/api/v1/wx/mps";
    QUrl url(apiUrl);
    
    QJsonObject requestBody;
    requestBody["mp_name"] = mpName;
    requestBody["mp_cover"] = mpCover;
    requestBody["mp_id"] = mpId;
    requestBody["avatar"] = "";
    requestBody["mp_intro"] = mpIntro;
    
    QJsonDocument doc(requestBody);
    QByteArray jsonData = doc.toJson();
    
    QNetworkAccessManager localManager;
    QNetworkRequest rq(url);
    rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
    rq.setRawHeader("Content-Type", "application/json");
    rq.setRawHeader("accept", "application/json");
    
    QNetworkReply* reply = localManager.post(rq, jsonData);
    
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray responseData = reply->readAll();
        qDebug() << "Add MP response:" << responseData;
        
        QJsonDocument responseDoc = QJsonDocument::fromJson(responseData);
        if (!responseDoc.isNull() && responseDoc.isObject()) {
            QJsonObject responseObj = responseDoc.object();
            if (responseObj.contains("code") && responseObj["code"].toInt() == 0) {
                return "SUCCESS: Added MP " + mpName;
            } else {
                QString message = responseObj.contains("message") ? responseObj["message"].toString() : "Unknown error";
                return "ERROR: " + message;
            }
        }
        return "SUCCESS: Added MP " + mpName;
    } else {
        qDebug() << "Error adding MP:" << reply->errorString();
        return "ERROR: " + reply->errorString();
    }
    
    reply->deleteLater();
}