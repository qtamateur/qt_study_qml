//学习TabView的使用！
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 360;
    height: 240;
    color: "lightgray";
    
    Component {
        id: tabContent;
        Rectangle {
            implicitWidth: 100;
            implicitHeight: 100;
            anchors.fill: parent;
            color: Qt.rgba(Math.random(), Math.random(), Math.random());
        }
    }

    Button {
        id: addTab;
        x: 8;
        y: 8;
        width: 60;
        height: 25;
        text: "AddTab";
        onClicked: {
            tabView.addTab("tab-" + tabView.count, tabContent);   //addTab(tiele,component)方法用于增加一个标签
            //insertTab(index,title,component)在指定索引位置插入一个标签、removeTab(index)、moveTab(from,to)顾名思义
            //getTab(index)返回指定位置标签对象(类型为Tab),Tab对象只有一个title属性，是Loader的派生类
        }
    }
    
    TabView {
        id: tabView;
        anchors.top: addTab.bottom;
        anchors.margins: 8;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
    }    
}
