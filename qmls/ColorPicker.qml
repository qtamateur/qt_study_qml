//单独定义一个组件的实例，定义Component时要遵守一个约定：组件名必须和QML文件名一致！而且组件名的第一个字母必须大写！！
//单独的组件也不需要Component对象，本文件的组件被component_file.qml和loader_component_file.qml文件调用了！！
import QtQuick 2.2

Rectangle {
    id: colorPicker;
    width: 50;
    height: 30;
    signal colorPicked(color clr);
    
    function configureBorder(){
        colorPicker.border.width = colorPicker.focus ? 2 : 0;  
        colorPicker.border.color = colorPicker.focus ? "#90D750" : "#808080"; 
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            colorPicker.colorPicked(colorPicker.color);
            mouse.accepted = true;
            colorPicker.focus = true;
        }
    }
    Keys.onReturnPressed: {   //响应回车按键
        colorPicker.colorPicked(colorPicker.color);
        event.accepted = true;
    }
    Keys.onSpacePressed: {   //响应空格按键
        colorPicker.colorPicked(colorPicker.color);
        event.accepted = true;
    }
    
    onFocusChanged: {
        configureBorder();
    }
    
    Component.onCompleted: {
        configureBorder();
    }
}
