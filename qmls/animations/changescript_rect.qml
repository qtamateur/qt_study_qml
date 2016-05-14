//State的使用！StateChangeScript来执行一个ECMAScript脚本，对应QQuickStateChangeScript,是QQuickStateOperation的派生类
import QtQuick 2.0
import "colorMaker.js" as ColorMaker

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: colorRect;
        color: "red";
        width: 150;
        height: 130;
        anchors.centerIn: parent;
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
        }        
        
        states: [
            State {
                name: "default";    
                when: mouseArea.pressed;         
                StateChangeScript { 
                    name: "changeColor";                     
                    script: ColorMaker.changeColor(colorRect);
                }
            }
        ]
    }
}
