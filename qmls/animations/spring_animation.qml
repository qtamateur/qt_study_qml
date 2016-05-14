//SpringAnimation模仿弹簧的震动行为
import QtQuick 2.2

Rectangle {
    id: rootItem;
    width: 320; 
    height: 240;
    
    Rectangle {
        id: rect;
        width: 40;
        height: 40;
        x: 20;
        y: 20;
        color: "red";    
    }

    SpringAnimation {
        id: springX;
        target: rect;
        property: "x";
        spring: 3;        //控制对象的加速度,0~0.5之间的取值是有意义的，默认值为0
        damping: 0.06;    //代表衰减系数,其值越大代表平复越快,0~1.0之间的值比较有意义
        epsilon: 0.25;    //允许你设定一个最接近0的阈值来代表0，基于像素位置的动画0.25比较合适、基于scale的动画0.005比较合适。默认0.01，调整其值可能带来一定的性能提升？？
    }        
        
    SpringAnimation {
        id: springY;
        target: rect; 
        property: "y";   
        spring: 3;
        damping: 0.06;
        epsilon: 0.25;
    }
    
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            springX.from = rect.x;
            springX.to = mouse.x - 20;
            springX.start();
            springY.from = rect.y;
            springY.to = mouse.y - 20;
            springY.start();
        }
    }        
}
