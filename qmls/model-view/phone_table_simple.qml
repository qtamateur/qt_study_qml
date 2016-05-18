//学习MVC里面的TableView，其比ListView多了滚动条、挑选、可调整尺寸的表头等特性，其Model定义都一样，但是delegate的定义相对简单！
//特别是数据有很多列的时候！！
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 360;
    height: 300;
    
    TableView {   //里面的TableViewColumn描述每一列，这是必须的，否则表格无法显示。示例中用到了role、title、width三个属性，这是要使用
        //TableViewColumn的最小属性集，role对应Model中ListElement中的role-name，正是这个属性完成了二维表格和一维Model之间的数据映射
        id: phoneTable;
        anchors.fill: parent;
        TableViewColumn{ role: "name"  ; title: "Name" ; width: 100; elideMode: Text.ElideRight;}
        TableViewColumn{ role: "cost" ; title: "Cost" ; width: 100; }        
        TableViewColumn{ role: "manufacturer" ; title: "Manufacturer" ; width: 140; }        
     
        model: ListModel {
            id: phoneModel;
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
        /*
        Component.onCompleted: {
            var col = Qt.createQmlObject("import QtQuick 2.0\nimport QtQuick.Controls 1.2\nTableViewColumn{ role: \"manufacturer\" ; title: \"Manufacturer\" ; width: 140; }", phoneModel);
            phoneTable.addColumn( col );
        }
        */
    }
}
