#include <iostream>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>

class cfgLoader:public QObject{
    Q_OBJECT
    cfgLoader(const QString &filepath){
        QFile cfg(filepath);
        
    }
}