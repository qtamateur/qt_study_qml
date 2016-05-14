//学习PathAnimation，其是Animation的派生类！专门让目标对象沿着一个既定的路径运动！
import QtQuick 2.2

Canvas {
    width: 400;
    height: 240;

    onPaint: {
        var ctx = getContext("2d");
        ctx.lineWidth = 4;
        ctx.strokeStyle = "red";
        ctx.beginPath();
        ctx.arc(200, 0, 160, Math.PI * 2, 0, false);
        ctx.stroke();
    }

    Rectangle {
        id: rect;
        width: 40; 
        height: 40;
        color: "blue";
        x: 20;
        y: 0;
        
        MouseArea {
            anchors.fill: parent;
            id: mouseArea;
            onClicked: pathAnim.start();
        }
    
        PathAnimation {
            id: pathAnim; 
            target: rect;
            duration: 6000;
            anchorPoint: "20,20";    //指定目标对象的哪个点锚定在路径上
            orientationEntryDuration: 200;   //设定完成这个旋转的时间
            orientationExitDuration: 200;
            easing.type: Easing.InOutCubic;
            orientation: PathAnimation.TopFirst;  //这个属性设置目标的旋转策略，自己查询各个意义！
            path: Path {   //构造的路径
                startX: 40; 
                startY: 0;
                PathArc { 
                    x: 360; 
                    y: 0; 
                    useLargeArc: true;
                    radiusX: 160;
                    radiusY: 160;
                    direction: PathArc.Counterclockwise;
                }
            }
        }
    }
}
