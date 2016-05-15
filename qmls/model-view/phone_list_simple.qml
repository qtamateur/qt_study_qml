//开始学习MVC设计模式下的Qt编程，ListView，显示一个条目列表，条目对应的数据来自于Model，条目的外观则有Delegate决定。
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    width: 360;
    height: 300;
    color: "#EEEEEE";

    Component { //delegate属性类型是Component，顶层元素是Row，其内嵌三个Text对象来展示Model定义的ListElement的三个role(name,cost,manufacturer)
    //ListView给delegate暴露一个index属性，代表当前delegate实例对应的Item的索引位置，可通过它访问数据
    //ListView定义了delayRemove/isCurrentItem/nextSection/previousSection/section/View等附件属性,以及add/remove两个附件信号，可以
    //在delegate的顶层Item内直接访问，非顶层Item则需要使用Item的id来访问，如Text中使用wrapper.ListView.isCurrentItem
        id: phoneDelegate;
        Item {
            id: wrapper;
            width: parent.width;
            height: 30;
            
            MouseArea {
                anchors.fill: parent;
                onClicked: [wrapper.ListView.view.currentIndex = index,console.log(index)]; //console为了显示index的数值，调试用的
            }
            
            RowLayout {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 8;
                Text { 
                    id: col1;
                    text: name; 
                    color: wrapper.ListView.isCurrentItem ? "red" : "black";
                    font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 120;
                }
                
                Text { 
                    text: cost; 
                    color: wrapper.ListView.isCurrentItem ? "red" : "black";
                    font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.preferredWidth: 80;
                }
                
                Text { 
                    text: manufacturer; 
                    color: wrapper.ListView.isCurrentItem ? "red" : "black";
                    font.pixelSize: wrapper.ListView.isCurrentItem ? 22 : 18;
                    Layout.fillWidth: true;
                }                
            }
        }
    }
    
    ListView {
        id: listView;
        anchors.fill: parent;

        delegate: phoneDelegate;
        
        model: ListModel {   //在ListView内部初始化了一个ListModel来专门定义列表数据，里面的ListElement对象代表一条数据
            id: phoneModel;
            ListElement{  //形式为--- <role-name>:<role-value>,其中name必须以小写开头，value必须是简单常量，如字符串、布尔值、数字或枚举值
                name: "iPhone 3GS";
                cost: "1000";
                manufacturer: "Apple";
            }
            ListElement{
                name: "iPhone 4";
                cost: "1800";
                manufacturer: "Apple";
            }            
            ListElement{
                name: "iPhone 4S";
                cost: "2300";
                manufacturer: "Apple";
            } 
            ListElement{
                name: "iPhone 5";
                cost: "4900";
                manufacturer: "Apple";
            }    
            ListElement{
                name: "B199";
                cost: "1590";
                manufacturer: "HuaWei";
            }  
            ListElement{
                name: "MI 2S";
                cost: "1999";
                manufacturer: "XiaoMi";
            }         
            ListElement{
                name: "GALAXY S5";
                cost: "4699";
                manufacturer: "Samsung";
            }                                                  
        }
        
        focus: true;

        highlight: Rectangle{   //highlight指定选择条目的浅蓝色背景，其Z序小于delegate实例化出来的Item对象,本例通过Rectangle来定义高亮背景
        //也可用Component来定制复杂高亮背景
            color: "lightblue";
        }
    }
}
