#本节学习qml实现手机应用中常用的捏拉手势
QT += qml quick

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

RESOURCES += qml.qrc

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml
