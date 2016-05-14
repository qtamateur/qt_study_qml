//PropertyAnimation的例子
import QtQuick 2.2

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Rectangle {
        id: rect;
        width: 50; 
        height: 150;
        anchors.centerIn: parent;
        color: "blue";
        
        MouseArea {
            anchors.fill: parent;
            id: mouseArea;
        }
        //Animation on <property>方式定义动画：
        PropertyAnimation on width {   //直接关联到width上面，不用设置target和property属性了，代码更简单！
            to: 150; duration: 1000;
            running: mouseArea.pressed;  //这种设置方式如果不设置running则在Item加载完毕后立即执行！
            //上一行使用ECMAScript，表示鼠标按下才动画，一旦释放立即停止！
        }
    }
}
