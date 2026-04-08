#include <QCoreApplication>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
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

class WebParser : public QObject
{
    Q_OBJECT
public:
    WebParser(QObject* parent = nullptr) : QObject(parent)
    {
        manager = new QNetworkAccessManager(this);
        connect(manager, &QNetworkAccessManager::finished,
            this, &WebParser::onFinished);
    }

    void fetchUrl(const QUrl& _url) {
        QNetworkRequest request(_url);
        manager->get(request);
    }

    QString postRq(const QString &model ,const QString &u_msg,
        const QString &s_msg,QUrl &baseUrl){
        /*Used for users.*/
        QJsonObject rqBody;
        rqBody["model"] = model;
        rqBody["stream"] = false;

        QJsonObject this_u_msg;
        this_u_msg["role"] = "user";
        this_u_msg["content"]  = u_msg;

        msgs.append(this_u_msg);
        rqBody["messages"] = msgs;
        
        QJsonDocument doc(rqBody);
        QByteArray jsonData = doc.toJson();

        QNetworkRequest rq(baseUrl);
        QNetworkReply* reply = manager->post(rq,jsonData);
        
        QString res = reply->readAll();
        return res;
    }

    QString postRq(const QString &model ,const QString &sys_prompt,
            QUrl &baseUrl){
        /*Used for single time call*/
        QJsonObject rqBody;
        rqBody["model"] = model;
        rqBody["stream"] = false;
        
        QJsonObject sysp;
        sysp["role"] = "system";
        sysp["content"] = sys_prompt;

        rqBody["messages"] = sysp;
        QJsonDocument doc;
		doc.setObject(rqBody);
        QByteArray jsonData = doc.toJson();

        QNetworkRequest rq(baseUrl);
        
		QNetworkReply* reply = manager->post(rq,jsonData);
        QString res = reply->readAll();
        return res;

    }

	QJsonArray msgs;
    

private slots:
    QString onFinished(QNetworkReply* reply) {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            qDebug() << "Data:" << data;

            return QString("OK");
        }
        else {
            qDebug() << "Error:" << reply->errorString();
            return QString("Error");
        }
        if (reply->isFinished())
        reply->deleteLater();
    }

private:
    QNetworkAccessManager* manager;

};