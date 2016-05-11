//加载多个图片的例子：一个本地图片、一个网络图片
import QtQuick 2.2

Canvas {
    width: 400;
    height: 300;
    id: root;
    property var dartlikeWeapon: "dartlike_weapon.png";
    property var poster: "http://g2.ykimg.com/0516000053548ED267379F510C0061FA";

    onPaint: {
        var ctx = getContext("2d");
        ctx.drawImage(poster, 120, 0);
        ctx.drawImage(dartlikeWeapon, 0, 0);
    }
    Component.onCompleted:{
        loadImage(dartlikeWeapon);   //该方法会异步加载图片，加载完成后会发送imageLoaded信号
        loadImage(poster);    //该方法会异步加载图片，加载完成后会发送imageLoaded信号
    }
    onImageLoaded: requestPaint();    //我们在对应的信号处理器中调用requestPaint()方法来重绘Canvas
}
