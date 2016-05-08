//学习动态创建、销毁Component(利用Loader)
//最好每个Component都写一个id，但是注意：id 用来标识QML对象，id不能够以大写字母开头，同样method也不能够以大写字母开头。
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 320;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    property var colorPickerShow : false;    //自定义属性,注意：property Type可以是QML的基本类型，一种QML对象类型,也可以是QML,可以是
    //C++通过Q_PROPERTY宏注册的类，还可以是JavaScript中的var,var它可以表示任何类型的数据，还可以是自定义的QML类型，如ColorPicked
    Text {
        id: coloredText;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 4;
        text: "Hello World!";
        font.pixelSize: 32;
    }
    
    Button {
        id: ctrlButton;
        text: "Show";
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        
        onClicked:{
           if(rootItem.colorPickerShow){
               redLoader.sourceComponent = undefined;   //卸载资源的第一种方法
               blueLoader.source = "";                  //卸载资源的第二种方法
               rootItem.colorPickerShow = false;
               ctrlButton.text = "Show";
           }else{
               redLoader.source = "ColorPicker.qml";
               redLoader.item.colorPicked.connect(onPickedRed);  //动态连接信号槽的方法！
               blueLoader.source = "ColorPicker.qml";
               blueLoader.item.colorPicked.connect(onPickedBlue);  //动态连接信号槽的方法！
               redLoader.focus = true;
               rootItem.colorPickerShow = true;
               ctrlButton.text = "Hide";
           }
        }
    }
    
    Loader{
        id: redLoader;
        anchors.left: ctrlButton.right;
        anchors.leftMargin: 4;
        anchors.bottom: ctrlButton.bottom;
        
        KeyNavigation.right: blueLoader;
        KeyNavigation.tab: blueLoader;
        
        onLoaded:{
            if(item != null){
                item.color = "red";
                item.focus = true;
            }
        }
        
        onFocusChanged:{  
            if(item != null){
                item.focus = focus;
            }
        }
    }
    
    Loader{
        id: blueLoader;
        anchors.left: redLoader.right;
        anchors.leftMargin: 4;
        anchors.bottom: redLoader.bottom;

        KeyNavigation.left: redLoader;
        KeyNavigation.tab: redLoader;
        
        onLoaded:{
            if(item != null){
                item.color = "blue";
            }
        }
        
        onFocusChanged:{
            if(item != null){
                item.focus = focus;
            }
        }  
    }
    
    function onPickedBlue(clr){
        coloredText.color = clr;
        if(!blueLoader.focus){
           blueLoader.focus = true;
           redLoader.focus = false;
        }
    }
    
    function onPickedRed(clr){
        coloredText.color = clr;
        if(!redLoader.focus){
           redLoader.focus = true;
           blueLoader.focus = false;
        }
    }
}
