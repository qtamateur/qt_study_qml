//学习使用TextInput，类似与Qt中的QLineEdit,但是简单多了！！！
//通常使用TextField，因为它有背景颜色！！
//多行文本编辑用：TextEdit和TextArea，区别也是无有背景颜色！！一般常用TextArea，它有背景，有滚动条啊！！！！
import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    width: 320;
    height: 240;
    color: "lightgray";

    TextInput {
        maximumLength: 10;
        width: 240;
        height: 30;
        font.pixelSize: 20
        anchors.centerIn: parent;
        selectByMouse: true;
        /*
        validator: RegExpValidator{ 
            regExp: new RegExp("(2[0-5]{2}|2[0-4][0-9]|1?[0-9]{1,2})\\.(2[0-5]{2}|2[0-4][0-9]|1?[0-9]{1,2})\\.(2[0-5]{2}|2[0-4][0-9]|1?[0-9]{1,2})\\.(2[0-5]{2}|2[0-4][0-9]|1?[0-9]{1,2})");
        }
        */
        //inputMask: "000.000.000.000;_";
        focus: true;
        selectedTextColor: "red";
        selectionColor: "blue";
    }    
}
