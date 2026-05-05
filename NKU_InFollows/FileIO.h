#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDir>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject* parent = nullptr);

    Q_INVOKABLE void save(const QString& jsonString,const QString& fileName);
	Q_INVOKABLE QString loadAsString(const QString& fileName);
    Q_INVOKABLE QVariantList listFiles(const QString& dirPath);
    Q_INVOKABLE QString read(const QString& filePath);
};

#endif // FILEIO_H