//学习transitions属性和Transition类，并行执行版本
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
            onPressed: {
                rect.state = "pressed";
            }
            onReleased: {
                rect.state = "";
            }
        }  
        
        states: State {
                    id: pressState;
                    name: "pressed";
                    //when: mouseArea.pressed;
                    PropertyChanges {
                        target: rect;
                        color: "green";
                        scale: "2.0";
                    }
                }
        transitions: Transition {  //from和to不设置则默认匹配所有状态，下面设置了to
            to: "pressed";
            reversible: true;     //这个属性指定触发transition的条件反转是Transition是否反转，默认为false，并发动画此属性无用！
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
