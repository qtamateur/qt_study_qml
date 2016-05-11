//第一个例子，简单介绍下：Canvas是Item的派生类，通过设置width和height属性，就可以定一个绘图区域，然后在onPaint()信号处理器内使用Context2D
//对象来绘图           两种方法画一个矩形
import QtQuick 2.2

/* Canvas画图的一般步骤：
 * 1.定一个Canvas对象，设置width、height
 * 2.定义onPaint信号处理器
 * 3.获取Context2D对象
 * 4.实际的绘图操作
 */

Canvas {
    width: 400;
    height: 240;

    onPaint: {
        var ctx = getContext("2d");    //getContext函数获取Context2D对象
        ctx.lineWidth = 2;
        ctx.strokeStyle = "red";
        ctx.fillStyle = "blue";
        ctx.beginPath();
        ctx.rect(100, 80, 120, 80);
        ctx.fill();
        ctx.stroke();
    }
}
/*
Canvas {
    width: 400;
    height: 240;
    contextType: "2d";   //当我们设置一个contextType属性后，context属性就会保存一个可用的Context2D对象！

    onPaint: {
        context.lineWidth = 2;
        context.strokeStyle = "red";
        context.fillStyle = "blue";
        context.beginPath();
        context.rect(100, 80, 120, 80);
        context.fill();
        context.stroke();
    }
}
*/
