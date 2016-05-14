//学习SmoothedAnimation，其是NumberAnimation的派生类！它的默认easing.type: Easing.OutCubic，在from和to之间产生平滑的动画效果！
import QtQuick 2.2

Rectangle {
    id: rootItem;
    width: 320; 
    height: 240;
    
    Rectangle {
        id: rect;
        width: 80;
        height: 60;
        x: 20;
        y: 20;
        color: "red";    
    }
    
    SmoothedAnimation {
        id: smoothX;
        target: rect;
        property: "x";
        duration: 1000;  //动画周期，单位ms，默认-1，表示禁用duration模式！
        velocity: -1;
    }        
        
    SmoothedAnimation {
        id: smoothY;
        target: rect; 
        property: "y";   
        velocity: 100;
    }
    
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            smoothX.from = rect.x;
            smoothX.to = mouse.x + 4;
            smoothX.start();
            smoothY.from = rect.y;
            smoothY.to = mouse.y + 4;
            smoothY.start();
        }
    }        
}
