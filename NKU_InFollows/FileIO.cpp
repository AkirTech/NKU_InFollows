#include "fileio.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QCoreApplication>

FileIO::FileIO(QObject* parent) : QObject(parent)
{
}

void FileIO::save(const QString& jsonString,const QString& fileName = QString("/Userdata.json"))
{
    // 这里指定保存路径，例如在应用程序目录下的 data.json
    //QString filePath = QCoreApplication::applicationDirPath() + "/data.json";
    QString filePath = QCoreApplication::applicationDirPath() + fileName;

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {

        qWarning() << "[Internal Error 503]" << file.errorString();
        return;
    }

    file.write(jsonString.toUtf8());
    file.close();
    qDebug() << "[OK 200]:" << filePath;
}