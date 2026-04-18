#pragma once

#include <iostream>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QObject>

class cfgLoader : public QObject{
    Q_OBJECT
public:
    cfgLoader(QString path);
    Q_INVOKABLE QString get(const QString &key);
    Q_INVOKABLE void set(const QString &key, const QString &value);
    QJsonObject mainObj;
};