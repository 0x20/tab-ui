#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "tqmembermodel.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    qmlRegisterType<TqMemberModel>("com.thequux.tab", 1, 0, "MemberModel");

    QQmlApplicationEngine engine;
    QPM_INIT(engine)
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
