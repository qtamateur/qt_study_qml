//学习transitions属性和Transition类，顺序执行版本
import QtQuick 2.2

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: rect;
        color: "gray";
        width: 50;
        height: 50;
        anchors.centerIn: parent;
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
        }  
        
        states: State {
                    id: pressState;
                    name: "pressed";
                    when: mouseArea.pressed;
                    PropertyChanges {
                        target: rect;
                        color: "green";
                        scale: "2.0";
                    }
                }
        transitions: Transition {
            SequentialAnimation {
                NumberAnimation {
                    property: "scale";
                    easing.type: Easing.InOutQuad;
                    duration: 1000;
                }
                ColorAnimation {
                    duration: 600;
                }
            }
        }
    }
}
