#pragma once
#include <QCoreApplication>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>
#include <QNetworkCookie>
#include <QUrl>
#include <QUrlQuery>
#include <QDebug>
#include <QEventLoop> 
#include <QByteArray>
#include <QObject>
#include <QMessageBox>
#include <QString>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QTimer>
#include <QProcess>
#include <string>
#include "cfgLoader.h"

#include <libs/cpp-base64-2.rc.08/base64.h>


class WebParser : public QObject
{
	Q_OBJECT
public:
	WebParser(QObject* parent = nullptr, cfgLoader *cfg = nullptr);
	~WebParser();
	
	void fetchUrl(const QUrl& _url);
	Q_INVOKABLE QString postAIRq(const QString& model, const QString& u_msg,
		const QString& s_msg, QUrl& baseUrl);
	Q_INVOKABLE QString postAIRq(const QString& model, const QString& sys_prompt,
		QUrl& baseUrl);
	QJsonArray msgs;
	
	void updateWxExpireTime();
	Q_INVOKABLE QJsonObject getMPSearchRq(const QString& search, const QUrl& Url, const QString access);
	Q_INVOKABLE QJsonObject getMPSearchRq(const QString& search, const QString& Url, const QString access);
	Q_INVOKABLE QString we_login(const QUrl Url,const QString& username, const QString& password);
	Q_INVOKABLE QString getLoginStatus(const QString &Url, const QString access);
	Q_INVOKABLE QString wxLoginGetQR(const QString& Url, const QString access);
	Q_INVOKABLE void wxLoginCheckLoop(const QString &Url, const QString access);
	Q_INVOKABLE QString checkRSSWxStatus(const QString& access);
	Q_INVOKABLE bool checkCurrentWxLogin();
	Q_INVOKABLE QString getWxExpireTime();
	Q_INVOKABLE bool startBackendService();
	Q_INVOKABLE void stopBackendService();
	Q_INVOKABLE QString getMPRefresh(const QString& Url, const QString access);
	Q_INVOKABLE QString getMPRecmd(const QString& Url, const QString access, int limit = 5);
	Q_INVOKABLE QString getAIAnalysis();
	Q_INVOKABLE void startSync();
	Q_INVOKABLE QString addMP(const QString& Url, const QString access, const QString& mpName, const QString& mpCover, const QString& mpId, const QString& mpIntro);
signals:
    void loginSuccess();
    void syncProgressUpdated(const QString& message, int progress);
    void syncCompleted(const QString& result);
    void syncError(const QString& error);


private:
	QNetworkAccessManager* manager;
	cfgLoader* config;
	QString m_checkUrl;
	QString m_accessToken;
	bool m_isLogin;
	QTimer* m_checkTimer;
	QProcess* m_backendProcess;
	void checkLoginStatusInternal();
private slots:
	Q_INVOKABLE QString onFinished(QNetworkReply* reply);
	void checkLoginStatus();
};
