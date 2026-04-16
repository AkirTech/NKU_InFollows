#include "cfgLoader.h"
#include <iostream>

cfgLoader::cfgLoader(QString path) {
    QFile cfg(path);
    if (cfg.open(QIODevice::ReadOnly)) {
        QByteArray data = cfg.readAll();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isNull()) {
            mainObj = doc.object();
        } else {
            std::cerr << "Failed to parse config file" << std::endl;
        }
    } else {
        std::cerr << "Failed to open config file: " << path.toStdString() << std::endl;
    }
}

QString cfgLoader::get(const QString &key) {
    return mainObj[key].toString();
}

void cfgLoader::set(const QString &key, const QString &value) {
    mainObj[key] = value;
    QJsonDocument doc(mainObj);
    QByteArray data = doc.toJson();
    QFile cfg("config.json");
    if (cfg.open(QIODevice::WriteOnly)) {
        cfg.write(data);
    } else {
        std::cerr << "Failed to write config file" << std::endl;
    }
}