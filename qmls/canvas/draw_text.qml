//学习绘制文字
import QtQuick 2.2

Canvas {
    width: 530;
    height: 300;
    id: root;

    onPaint: {
        var ctx = getContext("2d");
        ctx.lineWidth = 2;
        ctx.strokeStyle = "red";
        //ctx.font = "42px sans-serif";
        //ctx.font = "italic bold 32px serif" 
        //ctx.font = "italic 80 32px serif" 
        ctx.font = "normal small-caps normal 32px monospace"
        //font语法和CSS的font属性相同！！按顺序可以设定：
        //font-style(可选),normal italic oblique三值之一
        //font-variant(可选),normal small-caps二值之一
        //font-weight(可选),normal bold二值之一,或0~99的数字
        //font-size,取Npx或Npt，N为数字,px代表像素,pt代表点,对于移动设备,使用pt为单位更合适,能适应各种屏幕尺寸
        //font-family,常用的有serif sans-serif cursive fantasy monospace
        //可选属性如果没设置，会取默认值
        var gradient = ctx.createLinearGradient(0, 0, width, height);
        gradient.addColorStop(0.0, Qt.rgba(0, 1, 0, 1));
        gradient.addColorStop(1.0, Qt.rgba(0, 0, 1, 1));
        ctx.fillStyle = gradient;
        
        ctx.beginPath();
        ctx.text("Fill Text on Path", 10, 50);
        ctx.fill();
        
        ctx.fillText("Fill Text", 10, 100);
        
        ctx.beginPath();
        ctx.text("Stroke Text on Path", 10, 150);
        ctx.stroke();
        
        ctx.strokeText("Stroke Text", 10, 200);
        
        ctx.beginPath();
        ctx.text("Stroke and Fill Text on Path", 10, 250);
        ctx.stroke();
        ctx.fill();
    }
}
