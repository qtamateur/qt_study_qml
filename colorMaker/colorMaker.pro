#第一个关于如何在QML中使用C++类和对象的例子
TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    colorMaker.cpp


HEADERS += \
    colorMaker.h

RESOURCES += qml.qrc
