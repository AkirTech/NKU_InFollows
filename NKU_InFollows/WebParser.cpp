#include <QCoreApplication>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QUrl>
#include <QDebug>
#include <QEventLoop> // ����ͬ���ȴ�����ѡ��
#include <QByteArray>
#include <QObject>
#include <QMessageBox>
#include <QString>

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

    void fetchUrl(const QUrl& url) {
        QNetworkRequest request(url);
        manager->get(request);
    }

private slots:
    QString onFinished(QNetworkReply* reply) {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray data = reply->readAll();
            qDebug() << "Data:" << data;

            return QString::fromUtf8(data);
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