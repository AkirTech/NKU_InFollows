#include "fileio.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QCoreApplication>
#include <ctime>


time_t currentTime = time(nullptr);

QString defaultFilename = QString("/Userdata_%1.json").arg(currentTime);

FileIO::FileIO(QObject* parent) : QObject(parent)
{
}

void FileIO::save(const QString& jsonString,const QString& fileName = defaultFilename)
{
    // ����ָ������·����������Ӧ�ó���Ŀ¼�µ� data.json
    //QString filePath = QCoreApplication::applicationDirPath() + "/data.json";
    QString filePath = QCoreApplication::applicationDirPath() + "/" + fileName;

    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {

        qWarning()   << "FileIO:[Internal Error 503]" << file.errorString();
        return;
    }

    file.write(jsonString.toUtf8());
    file.close();
    qDebug() << "FileIO:[OK 200]:" << filePath;

}

QString FileIO::loadAsString(const QString& fileName)
{
    QString filePath = QCoreApplication::applicationDirPath() + "/" + fileName;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning()   << "FileIO:[Internal Error 503]" << file.errorString();
        return "";
    }
    QString String = QString::fromUtf8(file.readAll());
    file.close();
    qDebug() << "FileIO:[OK 200] Loaded.";
	return String;
}

QVariantList FileIO::listFiles(const QString& dirPath)
{
    QDir dir(dirPath);
    QStringList fileNames = dir.entryList(QDir::Files, QDir::Name);
    QVariantList result;
    for (const QString& fileName : fileNames) {
        result.append(fileName);
    }
    return result;
}

QString FileIO::read(const QString& filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "FileIO:[Read Error]" << file.errorString();
        return "";
    }
    QString content = QString::fromUtf8(file.readAll());
    file.close();
    qDebug() << "FileIO:[OK] Read:" << filePath;
    return content;
}