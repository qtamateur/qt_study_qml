#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "dynamicModel.h"

/* main函数new一个DynamicListModel对象，导出上下文环境的属性，这种做法经常使用！
 */

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty("dynamicModel", new DynamicListModel());
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
