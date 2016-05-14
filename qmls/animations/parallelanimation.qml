//学习ParallelAnimation，其是Animation的派生类！单独使用没有意义，其中定义多个动画会一块执行
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
                    anim.start();
                }
            }
        }        
        
        ParallelAnimation {
            id: anim;
            loops: Animation.Infinite;
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
