#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMessageBox>
#include <QQmlContext>
#include <qdebug.h>
#include "fileio.h"
#include "cfgLoader.h"
#include "WebParser.h"
#include <QProcessEnvironment>


static const QString pageURLs[50] {
    QStringLiteral("qrc:/qt/qml/nku_infollows/main.qml"),
    QStringLiteral("qrc:/qt/qml/nku_infollows/Eula.qml"),
    QStringLiteral("qrc:/qt/qml/nku_infollows/aiInit.qml"),
    QStringLiteral("qrc:/qt/qml/nku_infollows/mpSource.qml"),
    QStringLiteral("qrc:/qt/qml/nku_infollows/Greet.qml"),
	QStringLiteral("qrc:/qt/qml/nku_infollows/Collect1.qml"),
	QStringLiteral("qrc:/qt/qml/nku_infollows/finish .qml"),
};

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    //Set QML_XHR_ALLOW_FILE_READ to 1 to enable this feature.
    qputenv("QML_XHR_ALLOW_FILE_READ", "1");

    QGuiApplication app(argc, argv);
    cfgLoader maincfg("config.json");
	WebParser webParser;
    maincfg.set("appDirPath", QCoreApplication::applicationDirPath());
	FileIO fileIO;

    QString status = maincfg.get("OOBE");
    
	app.setWindowIcon(QIcon(QCoreApplication::applicationDirPath() + "/NKU_InFollows_icon.png"));
	qInfo() << "Application directory path: " << QCoreApplication::applicationDirPath();

#ifdef Q_OS_WIN
    QString username = QProcessEnvironment::systemEnvironment().value("USERNAME");
#else
    QString username = QProcessEnvironment::systemEnvironment().value("USER");
#endif

    qDebug() << QStringLiteral("当前用户名:") << username;
	maincfg.set("username", username);


    QQmlApplicationEngine engine;
    if (status == QStringLiteral("fresh")){
        engine.load(QUrl(pageURLs[0]));
    }
    else if (status == QStringLiteral("evaluate")){
        int progress = maincfg.get("oobe_progres").toInt();
        
        engine.load(QUrl(pageURLs[progress]));
    }
    else {
        engine.load(QUrl(QStringLiteral("qrc:/qt/qml/nku_infollows/main.qml")));
        
    }
    // engine.load(QUrl(QStringLiteral("qrc:/qt/qml/nku_infollows/main.qml")));
	engine.rootContext()->setContextProperty("appDirPath", QCoreApplication::applicationDirPath());
	engine.rootContext()->setContextProperty("FileIO", &fileIO);
	engine.rootContext()->setContextProperty("maincfg", &maincfg);
	engine.rootContext()->setContextProperty("webParser", &webParser);
		
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
