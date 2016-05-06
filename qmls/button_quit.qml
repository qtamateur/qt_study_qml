//学习如何使用按键进行单击事件
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 320;
    height: 240;
    color: "gray";
    
    Button {
        text: "Quit";
        anchors.centerIn: parent;
        onClicked: {
            Qt.quit();
        }
    }
}
