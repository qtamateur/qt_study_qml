//PropertyAnimation的例子
import QtQuick 2.2

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: rect;
        width: 50; 
        height: 150;
        anchors.centerIn: parent;
        color: "blue";
    
        PropertyAnimation { 
            id: animation; 
            target: rect;        //要操作的目标对象
            property: "width";   //指定要改变目标对象的那个属性
            to: 150;             //指定目标属性的目标值
            duration: 1000;      //属性为1000ms
        }
    
        MouseArea { 
            anchors.fill: parent; 
            onClicked: animation.start(); //animation.running = true;
        }
    }
}
