#本例子演示在MVC模式下，ListView使用C++里面的Model
TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    videoListModel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    videoListModel.h
