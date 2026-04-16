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

    QString postAIRq(const QString &model ,const QString &u_msg,
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
    QJsonObject getMPSearchRq(const QString &search,const QUrl &Url,const QString access) {
		QNetworkRequest rq(Url);
        rq.setRawHeader("Authorization", "Bearer " + access.toUtf8());
        rq.setRawHeader("accept", "application/json");
        QNetworkReply* reply = manager->get(rq);
        QJsonDocument res = QJsonDocument::fromJson(reply->readAll().data());
		QJsonArray list = res.object().value("list").toArray();
		QJsonObject firstItem = list.isEmpty() ? QJsonObject() : list.first().toObject();
		return firstItem;

    }
    QJsonObject getMPSearchRq(const QString& search, const QString& Url, const QString access) {
		return getMPSearchRq(search, QUrl(Url), access);
    }

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