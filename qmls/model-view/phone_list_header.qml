//开始学习MVC设计模式下的Qt编程，ListView，显示一个条目列表，条目对应的数据来自于Model，条目的外观则有Delegate决定。
//本例中定义了表头！
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    width: 360;
    height: 300;
    color: "#EEEEEE";
    
    Component {
        id: phoneModel;
        ListModel {
            ListElement{
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
    }
    
    Component {   //表头组件
        id: headerView;
        Item {
            width: parent.width;
            height: 30;
            RowLayout {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                spacing: 8;
                Text { 
                    text: "Name";
                    font.bold: true; 
                    font.pixelSize: 20;
                    Layout.preferredWidth: 120;
                }
                
                Text { 
                    text: "Cost"; 
                    font.bold: true;
                    font.pixelSize: 20;
                    Layout.preferredWidth: 80;
                }
                
                Text { 
                    text: "Manufacturer"; 
                    font.bold: true;
                    font.pixelSize: 20;
                    Layout.fillWidth: true;
                }                
            }            
        }
    }
    
    Component {
        id: phoneDelegate;
        Item {
            id: wrapper;
            width: parent.width;
            height: 30;
            
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    wrapper.ListView.view.currentIndex = index;
                    console.log("index=", index);
                    }    //可以在属性的值语句块内写入js语句！
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
        model: phoneModel.createObject(listView);  //这里不太懂，上下直接id，这里必须creat！！
        header: headerView;
        focus: true;
        highlight: Rectangle{
            color: "lightblue";
        }
    }
}
