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
    
        MouseArea { 
            anchors.fill: parent; 
            onClicked: PropertyAnimation {   //可以直接在信号处理器中直接定义动画元素
                        target: rect; 
                        properties: "width"; to: 150; duration: 1000;
                       }
        }
    }
}
