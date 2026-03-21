#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QString>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject* parent = nullptr);

    Q_INVOKABLE void save(const QString& jsonString,const QString& fileName);
};

#endif // FILEIO_H