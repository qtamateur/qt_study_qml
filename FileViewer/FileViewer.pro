# 本实例将会用到下列特性：
#ApplicationWindow
#MenuBar
#ToolBar、ToolButton
#Action
#StatusBar
#MediaPlayer
#Image
#XMLHttpRequest
#ColorDialog
#FileDialog
#TextArea
#动态创建QML组件
#多界面切换

TEMPLATE = app

QT += qml quick network multimedia widgets

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS +=
