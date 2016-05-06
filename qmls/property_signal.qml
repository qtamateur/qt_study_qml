//学习如何找到说明文档里没有提到的属性变化信号：
//1.找的QML类型对应的C++类型（通过console.log来输入对应QML的id号来查看）  2.查看对应源码里面的属性声明
import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    width: 320;
    height: 240;
    color: "gray";
    
    Text {
        id: hello;
        anchors.centerIn: parent;
        text: "Hello World!";
        color: "blue";
        font.pixelSize: 32;
        onTextChanged: {
            console.log(text);
        }
    }
    
    Button {
        anchors.top: hello.bottom;
        anchors.topMargin: 8;
        anchors.horizontalCenter: parent.horizontalCenter;
        text: "Change";
        onClicked: {
            hello.text = "Hello Qt Quick";
        }
    }
}
