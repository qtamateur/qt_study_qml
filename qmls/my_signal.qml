//学习自定义信号！更多请在帮助中搜索QML Signal and Handler Event System
import QtQuick 2.2
//import QtQuick.Controls 1.1

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
    //组件是可以重复利用的！
    Component {
        id: colorComponent;
        Rectangle {
            id: colorPicker;
            width: 50;
            height: 30;
            signal colorPicked(color clr);   //自定义信号
            MouseArea {
                anchors.fill: parent
                onPressed: colorPicker.colorPicked(colorPicker.color); //利用MouseArea里面的onPressed信号调用刚才自定义的信号
            }
        }
    }
    //定义好组件后，就可以用Loader来加载组件了！
    Loader{
        id: redLoader;
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        sourceComponent: colorComponent;
        onLoaded:{    //onLoader信号处理器给Rectangle对象配置颜色
            item.color = "red";    //item属性实际指向Loader创建的对象
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
        onColorPicked:{        //这里猜测原来Item有colorPicked信号则自动生成onColorPicked属性生成响应其信号！！没错：Signal Handler
//是一种特殊的 method 属性。当你在QML中文件中声明一个singal的时候，QML会自动帮你关联一个signal handler，这个signal handler默认是没有实现的。
//所以你只需要实现这个signal handler就可以了，然后在emitted一个signal的时候，与之关联的signal handler就会自动的被QML引擎调用。
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
