#演示如何使用定位功能的程序
TEMPLATE = app

QT += qml quick
QT += positioning
QT += network

SOURCES += main.cpp \
    ../qmls/model-view/stockMonitor/qDebug2Logcat.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

HEADERS += \
    ../qmls/model-view/stockMonitor/qDebug2Logcat.h
