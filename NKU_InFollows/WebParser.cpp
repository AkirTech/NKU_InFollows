#include <QCoreApplication>
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
#include "WebParser.h"
#include <libs/cpp-base64-2.rc.08/base64.h>


WebParser::WebParser(QObject* parent, cfgLoader* cfg) : QObject(parent), config(cfg)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished,
        this, &WebParser::onFinished);
}

void WebParser::fetchUrl(const QUrl& _url) {
    QNetworkRequest request(_url);
    manager->get(request);
}

QString WebParser::postAIRq(const QString &model ,const QString &u_msg,
    const QString &s_msg,QUrl &baseUrl){
    /*Used for users.*/
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
    
    // 等待网络请求完成
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
    /*Used for single time call*/
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
    
    // 等待网络请求完成
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
    
    // 等待网络请求完成
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

QJsonObject WebParser::getMPSearchRq(const QString& search, const QString& Url , const QString access) {
    return getMPSearchRq(search, QUrl(Url), access);
}

QString WebParser::we_login(const QUrl Url, const QString& username, const QString& password) {
    
	//check if currently have token
    QString c_token = config->get("mp.access_token");
    if (c_token != "") {
		qDebug() << "Already have token, skipping mp backend login.";
    }
    
    QNetworkRequest rq(Url);
    rq.setRawHeader("accept", "application/json");
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    // 构建form-urlencoded格式的请求体
    QByteArray postData;
    postData.append("grant_type=password&");
    postData.append("username=").append(QUrl::toPercentEncoding(username)).append("&");
    postData.append("password=").append(QUrl::toPercentEncoding(password)).append("&");
    postData.append("scope=&client_id=&client_secret=");

    // 使用局部的QNetworkAccessManager，避免触发全局的onFinished槽函数
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
                if (config) { // 添加空指针检查
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
	QNetworkRequest rq(Url+ "/api/v1/wx/auth/qr/code");
    ///api/v1/wx/auth/qr/code
	rq.setRawHeader("accept", "application/json");
	rq.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
    QNetworkReply* reply =  localManager.get(rq);
    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
	loop.exec();

	QNetworkRequest rq2(Url+"/api/v1/wx/auth/qr/image");
    rq2.setRawHeader("accept", "application/json");
	rq2.setRawHeader("Authorization", QString("Bearer %1").arg(access).toUtf8());
    QNetworkReply* reply2 =  localManager.get(rq2);
    QEventLoop loop2;
    connect(reply2, &QNetworkReply::finished, &loop2, &QEventLoop::quit);
	loop2.exec();

    QString 
}

QString WebParser::getLoginStatus(const QString &Url, const QString access) {
	QNetworkAccessManager localManager;

    QNetworkRequest rq(Url);
    rq.setRawHeader("accept", "application/json");
    rq.setHeader(QNetworkRequest::ContentTypeHeader, "application / x - www - form - urlencoded");
    rq.setRawHeader("Authorization:", QString("Bearer %1").arg(access).toUtf8());
    // /api/v1/wx/auth/qr/status  
	
	QNetworkReply* reply =  localManager.get(rq);

    QEventLoop loop;
    connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
	loop.exec();

	QString login_status; 
    QString qrcode_status;
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        qDebug() << "Response data:" << data;
        QJsonDocument res = QJsonDocument::fromJson(data);
        if (!res.isNull() && res.isObject()) {
			QJsonObject returndata = res.object().value("data").toObject();
            login_status = returndata.value("login_status").toString();
            qDebug() << "Login status:" << login_status;
        } else {
            qDebug() << "Error parsing JSON response";
        }
    } else {
        qDebug() << "Error in getLoginStatus:" << reply->errorString();
	}

    return login_status;
}




static QByteArray jsonToByteArray(const QJsonObject& json) {
    QJsonDocument doc(json);
    return doc.toJson();
}
	
    