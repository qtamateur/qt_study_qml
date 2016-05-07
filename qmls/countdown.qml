//学习使用定时器Timer
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 320;
    height: 240;
    color: "gray";
    QtObject{   //计数保存在次此对象中
        id: attrs;
        property int counter;
        Component.onCompleted:{   //附件信号处理器中初始化counter属性
            attrs.counter = 10;
        }
    }
    
    Text {
        id: countShow;
        anchors.centerIn: parent;
        color: "blue";
        font.pixelSize: 40;
    }
    
    Timer {
        //running属性，设置true定时器则开始工作，false则歇菜，默认false
        //还有start()、stop()、restart()三个方法，可以影响running属性。自己理解
        id: countDown;
        interval: 1000;  //指定定时周期，单位是ms，默认1000ms
        repeat: true;   //设定周期触发还是一次触发，默认一次
        triggeredOnStart: true;  //设置为true则定时器开始立刻触发一次，即第一次触发不算间隔时间，默认为false
        onTriggered:{
            countShow.text = attrs.counter;
            attrs.counter -= 1;
            if(attrs.counter < 0)
            {
                countDown.stop();
                countShow.text = "Clap Now!";
            }
        }
    }
    
    Button {
        id: startButton;
        anchors.top: countShow.bottom;
        anchors.topMargin: 20;
        anchors.horizontalCenter: countShow.horizontalCenter;
        text: "Start";
        onClicked: {   
            attrs.counter = 10;
            countDown.start();
        }
    }
}
