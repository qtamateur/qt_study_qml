//裁剪图像
import QtQuick 2.2

/* 裁剪图片的步骤：
 * 1.调用beginPath()
 * 2.使用lineTo(),arc(),bezierCurveTo(),moveTo(),closePath()等创建路径
 * 3.调用clip()确定裁剪区域
 * 4.绘图,如使用drawImage()
 */

Canvas {
    width: 480;
    height: 400;
    contextType: "2d";
    property var comicRole: "http://img.hb.aicdn.com/1561949785d9db35653b33bff99dc57b508f6cd2c7b0-GtelQQ_fw658";
    //下面构建了圆形+三角形的组合路径，用其围成的区域裁剪一个图片，然后旋转画布，绘制了一行文本，该文本也被裁剪了！
    onPaint: {
        context.lineWidth = 2;
        context.strokeStyle = "blue";   //strokeStyle与Qt C++中的QPen类似，用于保存描述图元边框的画笔，其取值与fillStyle类似
        context.fillStyle = Qt.rgba(0.3, 0.5, 0.7, 0.3);
        
        context.save();
        context.beginPath();
        context.arc(180, 150, 80, 0, Math.PI *2, true);
        context.moveTo(180, 230);
        context.lineTo(420, 280);
        context.lineTo(160, 320);
        context.closePath();
        context.clip();
        context.drawImage(comicRole, 0, 0, 600, 600, 0, 0, 400, 400);  
        context.stroke();
        context.fill();
        
        context.rotate(Math.PI / 5);
        context.font = "italic bold 32px serif" ;
        context.fillStyle = "red";   //fillStyle与Qt C++中的QBrush类似，保存用于填充图元的画刷，可以是一个颜色值，也可是CanvasGradient或CanvasPattern对象
        context.fillText("the text will be clipped!", 100, 70);        
        context.restore();  
    }
    
    Component.onCompleted:loadImage(comicRole);
    onImageLoaded: requestPaint();
}
