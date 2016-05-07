//使用Loader的source形式加载独立在一个文件中的Component
import QtQuick 2.2

Rectangle {
    width: 320;
    height: 240;
    color: "#EEEEEE";
    
    Text {
        id: coloredText;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 4;
        text: "Hello World!";
        font.pixelSize: 32;
    }
    
    Loader{
        id: redLoader;
        width: 80;
        height: 60;
        focus: true;
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        source: "ColorPicker.qml";
        KeyNavigation.right: blueLoader;
        KeyNavigation.tab: blueLoader;
        
        onLoaded:{
            item.color = "red";
            item.focus = true;
        }
        
        onFocusChanged:{  
            item.focus = focus;
        }
    }
    
    Loader{
        id: blueLoader;
        anchors.left: redLoader.right;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        source: "ColorPicker.qml";
        KeyNavigation.left: redLoader;
        KeyNavigation.tab: redLoader;
        
        onLoaded:{
            item.color = "blue";
        }
        
        onFocusChanged:{
            item.focus = focus;
        }  
    }

    Connections {
        target: redLoader.item;
        onColorPicked:{
            coloredText.color = clr;
            //注意这里和loader_focus.qml程序的区别！！！必须Loader有焦点，它加载的Item才会有焦点！
            //如果鼠标点击某个颜色选择组件而加载它的loader没有焦点，那么虽然颜色可以改变，但是焦点框出不来！！！！
            if(!redLoader.focus){
                redLoader.focus = true;
                blueLoader.focus = false;
            }
        }
    }
    
    Connections {
        target: blueLoader.item;
        onColorPicked:{
            coloredText.color = clr;
            if(!blueLoader.focus){
                blueLoader.focus = true;
                redLoader.focus = false;
            }
        }
    }
}
