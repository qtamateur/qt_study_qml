//渐变对象的使用！！
import QtQuick 2.2

/* Context2D绘制路径的一般步骤：
 * 1.调用beginPath()
 * 2.调用moveTo(),lineTo(),arcTo(),rect(),quadraticCurveTo(),arc(),bezierCurveTo()等可以构造路径元素的方法
 * 3.调用fill()或stroke()
 */

Canvas {
    width: 400;
    height: 240;

    onPaint: {
        var ctx = getContext("2d");
        ctx.lineWidth = 2;     //lineWidth属性设置画笔宽度
        ctx.strokeStyle = "red";   //strokeStyle与Qt C++中的QPen类似，用于保存描述图元边框的画笔，其取值与fillStyle类似
        var gradient = ctx.createLinearGradient(60, 50, 180, 130);    //创建一个线性渐变对象
        gradient.addColorStop(0.0, Qt.rgba(1, 0, 0, 1.0));     //添加渐变路径上的关键点的颜色
        gradient.addColorStop(1.0, Qt.rgba(0, 0, 1, 1.0));
        ctx.fillStyle = gradient;//fillStyle与Qt C++中的QBrush类似，保存用于填充图元的画刷，可以是一个颜色值，也可是CanvasGradient或CanvasPattern对象
        ctx.beginPath();
        ctx.rect(60, 50, 120, 80);
        ctx.fill();
        ctx.stroke();
        
        gradient = ctx.createRadialGradient(230, 160, 30, 260, 200, 20);  //创建一个放射渐变对象
        gradient.addColorStop(0.0, Qt.rgba(1, 0, 0, 1.0));
        gradient.addColorStop(1.0, Qt.rgba(0, 0, 1, 1.0));        
        ctx.fillStyle = gradient;
        ctx.beginPath();
        ctx.rect(200, 140, 80, 80);
        ctx.fill();
        ctx.stroke();        
    }
}
