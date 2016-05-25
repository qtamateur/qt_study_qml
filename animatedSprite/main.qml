//AnimatedSprite 元素用来播放精灵动画。
//一些常见的属性解释：
//source属性是url类型的，接受一个包含多帧的图片。
//frameWidth和frameHeight指定帧大小。
//frameX和frameY指定第一帧的左上角。
//frameCount指定这个精灵动画有多少帧。
//frameDuration指定每一帧的持续时间。相关的还有一个frameRate，指定帧率，即每秒播放多少帧。如果你指定了帧率，优先使用帧率来播放动画。
//paused 属性是bool值，指示动画是否处在暂停状态，默认是 false
//running 属性是bool值，指示动画是否在运行，默认是true，一启动就运行。如果你设置它为false，那AnimatedSprite对象构造完毕后并不运行，需要将其设置为 true 才开始运行。
//loops为int型，指示循环播放的次数，默认是无限循环
//方法：
//pause()，暂停动画
//resume()，继续播放
//restart()，重新播放，当动画处在播放状态时有效
//advance()，前进一帧，当动画处在暂停状态时有效
//注意：AnimatedSprite 元素使用的图片格式有特别的要求。 图片需要平铺所有的帧（和GIF不同），其实这里的帧就是图片里的一个区域。
//平铺的顺序是从左到右、从上到下。你指定了 frameX 、 frameY 、 frameWidth 、 frameHeight 、 frameCount ，AnimatedSprite
//就会分析你提供的图片，生成相关帧的信息。
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Window {
    visible: true;
    width: 360;
    height: 320;
    color: "black";

    AnimatedSprite {
        id: animated;
        width: 64;
        height: 64;
        anchors.centerIn: parent;
        source: "qrc:/numbers.png";
        frameWidth: 64;
        frameHeight: 64;
        frameDuration: 200;
        frameCount: 10;
        frameX: 0;
        frameY: 0;

        onCurrentFrameChanged: {
            info.text = "%1/%2".arg(animated.currentFrame).arg(animated.frameCount);
        }
    }

    Row{
        spacing: 4;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        Text {
            id: info;
            width: 60;
            height: 24;
            color: "red";
            verticalAlignment: Text.AlignVCenter;
            horizontalAlignment: Text.AlignRight;
        }

        Button {
            width: 60;
            height: 24;
            text: (animated.paused == true) ? "Play" : "Pause";
            onClicked:(animated.paused == true)?animated.resume():animated.pause();
        }

        Button {
            width: 70;
            height: 24;
            text: "Advance";
            onClicked: animated.advance();
        }

        Button {
            width: 70;
            height: 24;
            text: "Restart";
            onClicked: animated.restart();
        }


        Button {
            width: 60;
            height: 24;
            text: "Quit";
            onClicked: Qt.quit();
        }
    }
}
