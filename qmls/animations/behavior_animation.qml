//学习协同动画元素，Behavior,用来给属性定义默认动画，当属性变化时执行该动画，一个property只能绑定一个Behavior，一个Behavior内只能有一个顶层动画
import QtQuick 2.2

Rectangle {
    id: rootItem;
    width: 320; 
    height: 240;
    
    Rectangle {
        id: rect;
        width: 160;
        height: 100;
        color: "red";
        anchors.centerIn: parent;
        
        Behavior on width {
            NumberAnimation { duration: 1000; }
        }
        
        Behavior on height {
            NumberAnimation { duration: 1000; easing.type: Easing.InCubic; }
        }
        
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                rect.width = Math.random() * rootItem.width;
                rect.height = Math.min( Math.random() * rootItem.height, rect.height*1.5 );
            }
        }
    }
}
