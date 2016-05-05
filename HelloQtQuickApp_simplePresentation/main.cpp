#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QQuickView>

/* 总结两种启动Qt Quick APP模式：
 * 1.QQmlApplicationEngine搭配Window
 * 2.QQuickView搭配Item
 * 区别：第一种QML文档对窗口有完整控制权，可以直接设置标题、窗口尺寸等属性，而第二种对窗口的控制权在C++代码中！
 */

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;      //engine代表QML引擎
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));   //装载根qml文件
#if 0
    QQuickView viewer;
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl("qrc:/main.qml"));
    viewer.show();
#endif
    return app.exec();
}
