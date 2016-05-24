#本例是一个聊天例子，用来学习的主题有：
#1.适应多种分辨率的Android手机
#2.聊天界面
#3.录音
#4.Socket编程
TEMPLATE = app

QT += qml quick network multimedia

SOURCES += main.cpp \
    audiorecorder.cpp \
    messengerConnection.cpp \
    scanner.cpp \
    accessPointModel.cpp \
    pointSizeToPixelSize.cpp \
    ../qmls/model-view/stockMonitor/qDebug2Logcat.cpp \
    messengerManager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += \
    android/AndroidManifest.xml

HEADERS += \
    audiorecorder.h \
    messengerConnection.h \
    protocol.h \
    scanner.h \
    voiceMessage.h \
    accessPointModel.h \
    pointSizeToPixelSize.h \
    ../qmls/model-view/stockMonitor/qDebug2Logcat.h \
    messengerManager.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
