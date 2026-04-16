#pragma once
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
	WebParser(QObject* parent = nullptr);
	void fetchUrl(const QUrl& _url);
	QString postAIRq(const QString& model, const QString& u_msg,
		const QString& s_msg, QUrl& baseUrl);
	QString postAIRq(const QString& model, const QString& sys_prompt,
		QUrl& baseUrl);
	QJsonArray msgs;
	QJsonObject getMPSearchRq(const QString& search, const QUrl& Url, const QString access);
	QJsonObject getMPSearchRq(const QString& search, const QString& Url, const QString access);

private slots:
	QString onFinished(QNetworkReply* reply);

private:
	QNetworkAccessManager* manager;
};