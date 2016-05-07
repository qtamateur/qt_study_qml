//学习如何使用鼠标事件
import QtQuick 2.2

Rectangle {
    width: 320;
    height: 240;
    
    MouseArea {
        anchors.fill: parent;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;   //设定接受哪些鼠标事件
        onClicked: {   //clicked信号的参数是MouseEvent类型，名字为mouse！所以下面可以使用mouse名字
            if(mouse.button == Qt.RightButton){    //mouse的button属性保存按下鼠标按键的信息
                Qt.quit();
            }
            else if(mouse.button == Qt.LeftButton){
                color = Qt.rgba((mouse.x % 255) / 255.0 , (mouse.y % 255) / 255.0, 0.6, 1.0); //mouse的x、y属性保存点击位置
            }
        }
        onDoubleClicked: {
            color = "gray";
        }
    }
}
