//学习给style属性指定一个ButtonStyle来定制Button风格
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    width: 300;
    height: 200;
    Button {
        text: "Quit";
        anchors.centerIn: parent;
        style: ButtonStyle {
            background: Rectangle {    //background的属性类型是Component，用来绘制Button背景
                implicitWidth: 70;
                implicitHeight: 25;
                border.width: control.pressed ? 2 : 1;
                border.color: (control.hovered || control.pressed) ? "red" : "#888888";
            }
        }
        onClicked: Qt.quit();
    }
}
