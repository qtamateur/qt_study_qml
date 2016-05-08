//随时销毁的话必须将创建的对象放在一个数组里，这样就可以随时得到来删除！！好例子！！值得学习！！！
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: rootItem;
    width: 360;
    height: 300;
    property var count: 0;
    property Component component: null;
    property var dynamicObjects: new Array();   //用来存储创建出来的对象的数组，js中特有的
    
    Text {
        id: coloredText;
        text: "Hello World!";
        anchors.centerIn: parent;
        font.pixelSize: 24;
    }
    
    function changeTextColor(clr){
        coloredText.color = clr;
    }
    
    function createColorPicker(clr){
        if(rootItem.component == null){
            rootItem.component = Qt.createComponent("ColorPicker.qml");
        }
        var colorPicker;
        if(rootItem.component.status == Component.Ready) {
            colorPicker = rootItem.component.createObject(rootItem, {"color" : clr, "x" : rootItem.dynamicObjects.length *55, "y" : 10});
            colorPicker.colorPicked.connect(rootItem.changeTextColor);
            rootItem.dynamicObjects[rootItem.dynamicObjects.length] = colorPicker;
            console.log("add, rootItem.dynamicObject.length = ", rootItem.dynamicObjects.length);
        }
    }
    
    Button {
        id: add;
        text: "add";
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        onClicked: {
            createColorPicker(Qt.rgba(Math.random(), Math.random(), Math.random(), 1));
        }
    }
    Button {
        id: del;
        text: "del";
        anchors.left: add.right;
        anchors.leftMargin: 4;
        anchors.bottom: add.bottom;
        onClicked: {
            console.log("rootItem.dynamicObject.length = ", rootItem.dynamicObjects.length);
            if(rootItem.dynamicObjects.length > 0){
                //js中,splice()方法是修改Array的“万能方法”，它可以从指定的索引开始删除若干元素，然后再从该位置添加若干元素
                var deleted = rootItem.dynamicObjects.splice(-1, 1);   //这个方式值得学习，从末尾取值，不用管数组长度！
                deleted[0].destroy();
            }
        }
    }    
}
