#include <QtGui/QGuiApplication>
//#include <QtQuick/QQuickView>
#include <QQmlApplicationEngine>
#include "changeColor.h"
#include <QMetaObject>
#include <QDebug>
#include <QColor>
#include <QVariant>
//#include <QtQml>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    /*  QQuickView+item形式：
    QQuickView viewer;
    viewer.setResizeMode(QQuickView::SizeRootObjectToView);
    viewer.setSource(QUrl("qrc:///main.qml"));
    viewer.show();
    */

    //QQmlApplicationEngine+Window形式：
    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:///main.qml"));

    //root = qobject_cast<QObject*>(viewer.rootObject()); //如果使用QQuickView+item形式,下面一堆可以简化为这一句话！！
    //QQuickView::rootObject() const 方法-------->  Returns the view's root item.
    QObject * root = NULL;
    QList<QObject*> rootObjects = engine.rootObjects();
    int count = rootObjects.size();
    qDebug() << "rootObjects- " << count;
    for(int i = 0; i < count; i++)
    {
        if(rootObjects.at(i)->objectName() == "rootObject")
        {
            root = rootObjects.at(i);
            break;
        }
    }

    //找的正确root后把它交给一个ChangeQmlColor对象，该对象内使用定时器，1s改变一次传入对象的颜色
    new ChangeQmlColor(root);
    QObject * quitButton = root->findChild<QObject*>("quitButton");
    if(quitButton)
    {
        QObject::connect(quitButton, SIGNAL(clicked()), &app, SLOT(quit()));
    }

    QObject *textLabel = root->findChild<QObject*>("textLabel");
    if(textLabel)
    {
        //1. failed call 下面调用失败，因为QML的Text对象对应C++中QQuickText类，里面没有setText方法
        bool bRet = QMetaObject::invokeMethod(textLabel, "setText", Q_ARG(QString, "world hello")); //这个调用不含Type的重载函数
        //注意上面函数的使用，举个例子：To synchronously invoke the compute(QString, int, double) slot on some arbitrary object obj retrieve its return value:
//        QString retVal;
//        QMetaObject::invokeMethod(obj, "compute", Qt::DirectConnection,
//                                  Q_RETURN_ARG(QString, retVal),
//                                  Q_ARG(QString, "sqrt"),
//                                  Q_ARG(int, 42),
//                                  Q_ARG(double, 9.7));
        qDebug() << "call setText return - " << bRet;    //false，因为调用失败
        textLabel->setProperty("color", QColor::fromRgb(255,0,0));   //字变红啦！
        bRet = QMetaObject::invokeMethod(textLabel, "doLayout");
        qDebug() << "call doLayout return - " << bRet;   //调用成功！
    }
    return app.exec();
}
