#相当好的一个综合实例，一定要多多复习！！
TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    networkImageModel.cpp \
    directoryTraverse.cpp \
    ../../C++_study_onQT/qDebug2Logcat.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

HEADERS += \
    networkImageModel.h \
    networkImageModel_p.h \
    directoryTraverse.h \
    ../../C++_study_onQT/qDebug2Logcat.h

TRANSLATIONS += imageviewer_zh_CN.ts
