//ListView提供了add/remove/move/populate/displaced几种场景的过渡动画效果，可以通过设置相应的属性来改变特定场景对应的过渡动画，这些场景对应的
//属性，类型都是Transition
import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    width: 360;
    height: 300;
    color: "#EEEEEE";
    
    Component {
        id: phoneModel;
        ListModel {
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
    
    Component {
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
        id: footerView;
        Item{
            id: footerRootItem;
            width: parent.width;
            height: 30;
            signal add();
            signal insert();
            signal moveDown();
            
            Button {
                id: addOne;
                anchors.right: parent.right;
                anchors.rightMargin: 4;
                anchors.verticalCenter: parent.verticalCenter;
                text: "Add";
                onClicked: footerRootItem.add();
            }
            Button {
                id: insertOne;
                anchors.right: addOne.left;
                anchors.rightMargin: 4;
                anchors.verticalCenter: parent.verticalCenter;
                text: "Insert";
                onClicked: footerRootItem.insert();
            }            
            Button {
                id: moveDown;
                anchors.right: insertOne.left;
                anchors.rightMargin: 4;
                anchors.verticalCenter: parent.verticalCenter;
                text: "Down";
                onClicked: footerRootItem.moveDown();
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
                id: delegateMouseArea;
                anchors.fill: parent;

                onClicked: {
                    wrapper.ListView.view.currentIndex = index ;
                    mouse.accepted = true;
                }
                
                onDoubleClicked: {
                    wrapper.ListView.view.model.remove(index);    
                    mouse.accepted = true;       
                }
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
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent;
        interactive: false;

        delegate: phoneDelegate;
        model: phoneModel.createObject(listView);
        header: headerView;
        footer: footerView;
        focus: true;
        highlight: Rectangle{
            color: "lightblue";
        }
        
        add: Transition {    //增加add的过渡动画：指定向ListView新增一个Item时针对该Item应用的过渡动画
            ParallelAnimation{
                NumberAnimation {
                    property: "opacity";   //变化透明度
                    from: 0;
                    to: 1.0;
                    duration: 1000;
                }
                NumberAnimation {            //变化x y的属性
                    properties: "x,y";
                    from: 0;
                    duration: 1000;
                }
            }
        }
        
        displaced: Transition {   //增加displaced的过渡动画：指定通用的、由于Model变化导致Item位移时的动画效果
                SpringAnimation {
                    property: "y";   
                    spring: 3;
                    damping: 0.1;
                    epsilon: 0.25;
                }
        }
        
        remove: Transition {    //增加remove的过渡动画：指定将一个Item从ListView移除一个Item时针对该Item应用的过渡动画
            SequentialAnimation{
                NumberAnimation {
                    properties: "y";
                    to: 0;
                    duration: 600;
                }            
                NumberAnimation {
                    property: "opacity";
                    to: 0;
                    duration: 400;
                }

            }
        }
        
        move: Transition {      //增加move的过渡动画：指定移动一个Item时要应用的过渡动画
            NumberAnimation {
                property: "y";
                duration: 700;
                easing.type: Easing.InQuart;
            }
        }
        
        populate: Transition {      //增加populate的过渡动画：指定一个在ListView第一次实例化或因Model变化而需要创建Item时的过渡动画
                NumberAnimation {
                    property: "opacity";
                    from: 0;
                    to: 1.0;
                    duration: 1000;
                }        
        }
        
        function addOne(){
            model.append(
                        {
                            "name": "MX3",
                            "cost": "1799",
                            "manufacturer": "MeiZu"
                        } 
                    );
        }
        
        function insertOne(){
            model.insert( Math.round(Math.random() * model.count),
                        {
                            "name": "HTC One E8",
                            "cost": "2999",
                            "manufacturer": "HTC"
                        } 
                    );
        }
        
        function moveDown(){
            if(currentIndex + 1 < model.count){
                model.move(currentIndex, currentIndex+1, 1);
            }
        }
        
        Component.onCompleted: {
            listView.footerItem.add.connect(listView.addOne);
            listView.footerItem.insert.connect(listView.insertOne);
            listView.footerItem.moveDown.connect(listView.moveDown);
        }      
    }
}
