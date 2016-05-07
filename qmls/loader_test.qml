//学习如何使用Loader:
//1.可以通过source属性加载一个QML文档；
//2.可以通过sourceComponent属性加载一个Component对象。
//当你需要延迟一些直到真正需要才创建的对象时，Loader非常有用！当Loader的source或sourceComponent属性发生改变时，它之前加载的Component会
//自动销毁，新对象会被加载。将source设置为一个空字符串或者将sourceComponent设置为undefined，将会销毁当前加载的对象，相关资源也会被释放，而
//Loader对象则变成一个空对象。
import QtQuick 2.2

Rectangle {
    width: 320;
    height: 240;
    color: "#C0C0C0";
    
    Text {
        id: coloredText;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 4;
        text: "Hello World!";
        font.pixelSize: 32;
    }
    
    Component {
        id: colorComponent;
        Rectangle {
            id: colorPicker;
            width: 50;
            height: 30;
            signal colorPicked(color clr);
            MouseArea {
                anchors.fill: parent
                onPressed: colorPicker.colorPicked(colorPicker.color);
            }
        }
    }
/*Loader的Item属性指向它加载的顶层Item，比如下面的Loader的Item属性就指向颜色选择组件的Rectangle对象。其暴露出来的属性、信号等都可一个通过
 *Loader的Item属性来访问，因此才可以向下面那要使用item.color(代表colorPicker.color)！
 */
    Loader{
        id: redLoader;
        width: 80;
        height: 60;
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        sourceComponent: colorComponent;
        onLoaded:{
            item.color = "red";
        }
    }
    
    Loader{
        id: blueLoader;
        anchors.left: redLoader.right;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        sourceComponent: colorComponent;
        onLoaded:{
            item.color = "blue";
        }
    }
    
    Connections {
        target: redLoader.item;
        onColorPicked:{           //这里猜测原来Item有colorPicked信号则自动生成onColorPicked属性生成响应其信号！！
            coloredText.color = clr;
        }
    }
    
    Connections {
        target: blueLoader.item;
        onColorPicked:{
            coloredText.color = clr;
        }
    }
}
