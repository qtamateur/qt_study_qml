/* FlatButton把孩子们的很多属性通过alias暴露出来，这时我们定义组件时的常用技巧，本程序代表自定义的一个按钮
 */
import QtQuick 2.2

Rectangle {
    id: bkgnd;
    implicitWidth: 120;
    implicitHeight: 50;
    color: "transparent";
    property alias iconSource: icon.source;  //将组件中的一个属性设置为可定义,即用关键字property alias将一个属性设置一个别名
                                             //注意：外部使用iconSource啊！！如本例将icon.source--->iconSource!!
    property alias iconWidth: icon.width;
    property alias iconHeight: icon.height;
    property alias textColor: btnText.color;
    property alias font: btnText.font;
    property alias text: btnText.text;
    radius: 6;
    property bool hovered: false;
    border.color: "#949494";
    border.width: hovered ? 2 : 0;
    signal clicked;

    Image {
        id: icon;
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter;
    }
    Text {
        id: btnText;
        anchors.left: icon.right;
        anchors.verticalCenter: icon.verticalCenter;
        anchors.margins: 4;
        color: ma.pressed ? "blue" : (parent.hovered ? "#0000a0" : "white");
    }
    MouseArea {
        id: ma;
        anchors.fill: parent;
        hoverEnabled: true;   //设置为true，这样桌面平台上可以通过悬停状态改变按钮外观！
        onEntered: {
            bkgnd.hovered = true;
        }
        onExited: {
            bkgnd.hovered = false;
        }
        onClicked: {   //鼠标单机时，触发bkgnd的clicked信号，所以外部使用时可以通过bkgnd的onClicked信号处理器来响应按钮动作
            bkgnd.hovered = false;
            bkgnd.clicked();
        }
    }
}

