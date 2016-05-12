#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml>
#include "colorMaker.h"

/* 将一个C++类型注册为QML类型并使用的步骤：
 * 1.实现C++类
 * 2.注册QML类型
 * 3.在QML中导入类型
 * 4.在QML中创建由C++导出的实例并使用
 */
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    //qmlRegisterType<ColorMaker>("an.qt.ColorMaker", 1, 0, "ColorMaker");  //[1]第一种注册方法，参数分别代表：包名、主版本号、次版本号、QML中可以使用的类名

    QQuickView viewer;
    QObject::connect(viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));   //[2]
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.rootContext()->setContextProperty("colorMaker", new ColorMaker);  //[3]这行代码从堆上分配一个ColorMaker对象，然后注册为QML上下文属性，起的名字交colorMaker
    //去掉了[1],因此main.qml中不能访问ColorMaker类了。但是上面这句话使得QML中不需要import语句了！
    viewer.setSource(QUrl("qrc:///main.qml"));
    viewer.show();

    return app.exec();
}
