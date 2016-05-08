//学习动态创建、销毁Component(利用ECMAScript):
//1.使用Qt.createComponent()动态地创建一个组件对象，然后使用Component的createObject()方法创建对象
//2.使用Qt.createQmlObject()从一个QML字符串直接创建一个对象
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: rootItem;
    width: 360;
    height: 300;
    property var count: 0;
    property Component component: null;
    
    Text {
        id: coloredText;
        text: "Hello World!";
        anchors.centerIn: parent;
        font.pixelSize: 24;
    }
    
    function changeTextColor(clr){
        coloredText.color = clr;
    }
    
    function createColorPicker(clr){
        if(rootItem.component == null){
            rootItem.component = Qt.createComponent("ColorPicker.qml");  //使用第一种方法的第一步
        }
        var colorPicker;
        if(rootItem.component.status == Component.Ready) {
            //使用第一种方法的第二步
            colorPicker = rootItem.component.createObject(rootItem, {"color" : clr, "x" : rootItem.count *55, "y" : 10});
            colorPicker.colorPicked.connect(rootItem.changeTextColor);
        }
        
        rootItem.count++;
    }

    Button {
        id: add;
        text: "add";
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        onClicked: {
            createColorPicker(Qt.rgba(Math.random(), Math.random(), Math.random(), 1));
        }
    }
}
