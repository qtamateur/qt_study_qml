//State的使用！PropertyChanges来改变对象的属性，对应QQuickPropertyChanges,是QQuickStateOperation的派生类
import QtQuick 2.2

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: rect;
        color: "blue";
        width: 200;
        height: 200;
        anchors.centerIn: parent;
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
        }        
        
        states: [
            State {
                name: "resetwidth";
                when: mouseArea.pressed;
                PropertyChanges{ 
                    target: rect;   //要改变的目标！
                    restoreEntryValues: false;  //设为false，则这种改变是持久的，默认为true
                    color: "red"; 
                    width: parent.width; 
                }
            }
        ]
    }
}
