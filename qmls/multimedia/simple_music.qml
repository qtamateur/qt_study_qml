//MediaPlayer是QML提供的核心多媒体类，可以播放音频、视频
import QtQuick 2.2
import QtMultimedia 5.0   //使用MediaPlayer的模块
Rectangle {
    width: 200;
    height: 100;

    MediaPlayer {
        autoPlay: true;  //表明创建对象后立即开始播放
        source: "wangjie_game_and_dream.mp3";
    }
}
