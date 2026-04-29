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
#include <string>
#include "WebParser.h"


WebParser::WebParser(QObject* parent, cfgLoader* cfg) : QObject(parent), config(cfg), m_isLogin(false)
{
    manager = new QNetworkAccessManager(this);
    m_checkTimer = new QTimer(this);
    connect(m_checkTimer, &QTimer::timeout, this, &WebParser::checkLoginStatus);
    connect(manager, &QNetworkAccessManager::finished,
        this, &WebParser::onFinished);
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

    QJsonObject this_u_msg;
    this_u_msg["role"] = "user";
    this_u_msg["content"] = u_msg;

    msgs.append(this_u_msg);
    rqBody["messages"] = msgs;
        
    QJsonDocument doc(rqBody);
    QByteArray jsonData = doc.toJson();

    QNetworkRequest rq(baseUrl);
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    QNetworkReply* reply = manager->post(rq, jsonData);
    
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
        
    QNetworkReply* reply = manager->post(rq, jsonData);
    
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

QJsonObject WebParser::getMPSearchRq(const QString &search, const QUrl &Url, const QString access) {
    QNetworkRequest rq(Url);
    rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
    rq.setRawHeader("accept", "application/json");
    
    QNetworkReply* reply = manager->get(rq);
    
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();
    
    QJsonObject result;
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        QJsonDocument res = QJsonDocument::fromJson(data);
        if (!res.isNull() && res.isObject()) {
            QJsonArray list = res.object().value("list").toArray();
            result = list.isEmpty() ? QJsonObject() : list.first().toObject();
        } else {
            qDebug() << "Error parsing JSON response";
        }
    } else {
        qDebug() << "Error in getMPSearchRq:" << reply->errorString();
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
    
    // 第一步：获取二维码
	QNetworkRequest rq(Url+ "/api/v1/wx/auth/qr/code");
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

QString WebParser::realIDConstructor(const QString& id) {
	std::string decoded = base64_decode(id.toStdString());
	return QString::fromStdString(std::string("MP_WXS_"+decoded));
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
