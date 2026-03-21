#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QMessageBox>
#include <QQmlContext>
#include "fileio.h"
int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN) && QT_VERSION_CHECK(5, 6, 0) <= QT_VERSION && QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif


	FileIO fileIO;

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/nku_infollows/main.qml")));
	engine.rootContext()->setContextProperty("appDirPath", QCoreApplication::applicationDirPath());
	engine.rootContext()->setContextProperty("FileIO", &fileIO);
	
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
