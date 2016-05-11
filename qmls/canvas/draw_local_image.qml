import QtQuick 2.2

Canvas {
    width: 400;
    height: 300;
    id: root;
    property var dartlikeWeapon: "dartlike_weapon.png";   //保存图片的URL

    onPaint: {
        var ctx = getContext("2d");
        ctx.drawImage(dartlikeWeapon, 0, 0);  //在指定位置绘制Image元素、一个图片URL、或者一个CanvasImageData对象
    }
    Component.onCompleted:{
        loadImage(dartlikeWeapon);   //该方法会异步加载图片，加载完成后会发送imageLoaded信号
    }
    onImageLoaded: {   //我们在对应的信号处理器中调用requestPaint()方法来重绘Canvas
        console.log("image loaded");
        requestPaint();
    }
}
