//学习SequentialAnimation，其是Animation的派生类！单独使用没有意义，其中定义多个动画会一个个执行
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
                if(anim.paused) {
                    anim.resume();
                }else if(anim.running){
                    anim.pause();
                }else{
                    rect.radius = 0;
                    rect.x = 0;
                    rect.rotation = 0;
                    anim.start();
                }
            }
        }        
        
        SequentialAnimation {
            id: anim;
            NumberAnimation { 
                target: rect; 
                property: "x"; 
                to: 310; 
                duration: 3000; 
            }
            NumberAnimation { 
                target: rect; 
                property: "rotation"; 
                to: 360; 
                duration: 1000; 
                loops: 3; 
            }
            NumberAnimation { 
                target: rect; 
                property: "radius"; 
                to: 25; 
                duration: 3000; 
            }
        }
    }
}
