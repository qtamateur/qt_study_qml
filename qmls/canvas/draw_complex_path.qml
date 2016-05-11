import QtQuick 2.2

Canvas {
    width: 400;
    height: 300;
    id: root;

    onPaint: {
        var ctx = getContext("2d");
        ctx.lineWidth = 2;       //lineWidth属性设置画笔宽度
        ctx.strokeStyle = "red";   //strokeStyle与Qt C++中的QPen类似，用于保存描述图元边框的画笔，其取值与fillStyle类似
        ctx.font = "42px sans-serif";
        var gradient = ctx.createLinearGradient(0, 0, width, height);    //创建一个线性渐变对象
        gradient.addColorStop(0.0, Qt.rgba(0, 1, 0, 1));
        gradient.addColorStop(1.0, Qt.rgba(0, 0, 1, 1));
        ctx.fillStyle = gradient; //fillStyle与Qt C++中的QBrush类似，保存用于填充图元的画刷，可以是一个颜色值，也可是CanvasGradient或CanvasPattern对象
        ctx.beginPath();
        ctx.moveTo(4, 4);
        ctx.bezierCurveTo(0, height - 1, width -1, height / 2, width / 4, height / 4);  //三次方贝塞尔曲线
        ctx.lineTo(width/2, height/4);    //直线
        ctx.arc(width*5/8, height/4, width/8, Math.PI, 0, false);  //弧线
        ctx.ellipse(width*11/16, height/4, width/8, height/4);   //椭圆
        ctx.lineTo(width/2, height*7/8);
        ctx.text("Complex Path", width/4, height*7/8);    //绘制文字
        ctx.fill();
        ctx.stroke();
    }
}
