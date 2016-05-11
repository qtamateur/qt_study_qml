//画了一个三角形
import QtQuick 2.2

Canvas {
    width: 400;
    height: 240;
    contextType: "2d";

    onPaint: {
        context.lineWidth = 2;  //lineWidth属性设置画笔宽度
        context.strokeStyle = "red";   //strokeStyle与Qt C++中的QPen类似，用于保存描述图元边框的画笔，其取值与fillStyle类似
        context.fillStyle = "blue"; //fillStyle与Qt C++中的QBrush类似，保存用于填充图元的画刷，可以是一个颜色值，也可是CanvasGradient或CanvasPattern对象
        context.beginPath();
        context.moveTo(100, 80);
        context.lineTo(100, 200);
        context.lineTo(300, 200);
        context.closePath();   //closePath方法用于结束当前的路径，从路径终点到起点绘制一条路线来封闭路径
        context.fill();     //根据fillStyle来填充三角形
        context.stroke();   //stroke完成了描绘边框的工作
    }
}
