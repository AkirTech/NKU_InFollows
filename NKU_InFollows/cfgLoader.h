#include <iostream>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

class cfgLoader : public QObject{
    Q_OBJECT
public:
    cfgLoader(QString path);
    QString getCfg(const QString &key);
    void setCfg(const QString &key, const QString &value);
    QJsonObject mainObj;
};