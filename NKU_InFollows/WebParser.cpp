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


WebParser::WebParser(QObject* parent) : QObject(parent)
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

QJsonObject WebParser::getMPSearchRq(const QString& search, const QString& Url, const QString access) {
    return getMPSearchRq(search, QUrl(Url), access);
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


	
    