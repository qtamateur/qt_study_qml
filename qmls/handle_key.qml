//学习处理键盘事件，注意keys对象是专门供Item处理按键事件的对象，它有两个常用信号pressed和released，这两个信号有一个名字为event，类型
//是KeyEvent的参数，包含了按键的详细信息！！
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 320;
    height: 280;
    color: "gray";
    
    focus: true;   //焦点设置为true才能得到事件！
    Keys.enabled: true;
    Keys.onEscapePressed: {
        Qt.quit();
    }
    Keys.forwardTo: [moveText, likeQt]; //forwardTo属性表示传递按键事件给列表内的对象
    
    Text {
        id: moveText;
        x: 20;
        y: 20;
        width: 200;
        height: 30;
        text: "Moving Text";
        color: "blue";
        //focus: true;
        font { bold: true; pixelSize: 24;}
        Keys.enabled: true;   //enabled属性设置是否处理按键
        Keys.onPressed: {
            switch(event.key){
            case Qt.Key_Left:
                x -= 10;
                break;
            case Qt.Key_Right:
                x += 10;
                break;
            case Qt.Key_Down:
                y += 10;
                break;
            case Qt.Key_Up:
                y -= 10;
                break;
            default:
                return;
            }
            event.accepted = true;   //按键事件处理后其accepted属性应该设置true，防止继续传递
        }
    }
    
    CheckBox {   //checkBox本身就会处理空格按键来选中或者取消复选框！
        id: likeQt;
        text: "Like Qt Quick";
        anchors.left: parent.left;
        anchors.leftMargin: 10;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 10;
        z: 1;
    }
}
