#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMessageBox>
#include <QQmlContext>
#include <qdebug.h>
#include "fileio.h"
#include "cfgLoader.h"

static const QString pageURLs[50] {
    QStringLiteral("qrc/");
    
}

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    cfgLoader maincfg("config.json");
    maincfg.setCfg("appDirPath", QCoreApplication::applicationDirPath());
	FileIO fileIO;

    QString status = maincfg.load("OOBE");
    
	app.setWindowIcon(QIcon(QCoreApplication::applicationDirPath() + "/NKU_InFollows_icon.png"));
	qInfo() << "Application directory path: " << QCoreApplication::applicationDirPath();

    QQmlApplicationEngine engine;
    if (status == QStringLiteral("fresh")){
        engine.load(QUrl(QStringLiteral("......")))
    }
    else if (status == QStringLiteral("evaluate")){
        int progress = maincfg.load("oobe_progress").toInt();
        
        engine.load(QUrl(pageURLs[progress]));
    }
    // engine.load(QUrl(QStringLiteral("qrc:/qt/qml/nku_infollows/main.qml")));
	engine.rootContext()->setContextProperty("appDirPath", QCoreApplication::applicationDirPath());
	engine.rootContext()->setContextProperty("FileIO", &fileIO);
	engine.rootContext()->setContextProperty("maincfg", &maincfg);
		
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
