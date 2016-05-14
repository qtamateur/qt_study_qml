//学习NumberAnimation，其是PropertyAnimation的派生类！专门处理数字类型的property
import QtQuick 2.2

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: rect;
        color: "blue";
        width: 50;
        height: 50;
        x: 0;
        y: 95;
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
            onClicked: {
                animationX.start();
                animationRotation.running = true;
                animationRadius.start();
            }
        }        

        NumberAnimation { 
            id: animationX;
            target: rect; 
            property: "x"; 
            to: 310; 
            duration: 3000; 
            easing.type: Easing.OutCubic;  //Easing curve for a quadratic (t^2) function: decelerating to zero velocity.
        }
        
        NumberAnimation { 
            id: animationRotation;
            target: rect; 
            property: "rotation";
            to: 1080; 
            duration: 3000; 
            running: false;
            easing.type: Easing.OutInQuad;  //Easing curve for a quadratic (t^2) function: deceleration until halfway, then acceleration.
        }
        
        NumberAnimation on radius { 
            id: animationRadius;
            to: 25; 
            duration: 3000; 
            running: false;
        }
    }
}
