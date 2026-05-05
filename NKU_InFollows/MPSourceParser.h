#pragma once
#include <QJsonObject>
#include <QCoreApplication>
#include <QString>
#include <QJsonDocument>
#include <QObject>

class MPSourceParser : public QObject {
	Q_OBJECT
public:
	Q_INVOKABLE QString getNickname(const QJsonObject& source);
	Q_INVOKABLE QString getDescription(const QJsonObject& source);
	Q_INVOKABLE QString getRealID(const QJsonObject& source);
	Q_INVOKABLE QString getRawID(const QJsonObject& source);
	Q_INVOKABLE QString getAvatar(const QJsonObject& source);
	
};