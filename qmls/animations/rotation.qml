//学习RotationAnimation，其是PropertyAnimation的派生类！专门处理rotation和angle两个property
import QtQuick 2.0

/* RotationAnimation新增了一个direction属性：
 * RotationAnimation.Numerical,默认值,from到to角度直接线性插值进行旋转，eg. from=10  to=100,代表顺时针旋转90度
 * RotationAnimation.Clockwise,两个角度间顺时针旋转   RotationAnimation.Counterclockwise, 两个角度间逆时针旋转
 * RotationAnimation.Shortest,两个角度间最短路径旋转  eg.  from=10  to=350,代表逆时针旋转20度
 * 使用时不需要指定property属性！其旋转一个Item时以Item的transformOrigin属性指定旋转中心,默认Item.Center,还可以取得：Item.Top Item.TopRight等
 */

Rectangle {
    width: 320;
    height: 240;
    color: "#EEEEEE";
    
    Rectangle {
        id: rect;
        color: "red";
        width: 120;
        height: 60;
        anchors.left: parent.left;
        anchors.leftMargin: 20;
        anchors.verticalCenter: parent.verticalCenter;
        
        MouseArea {
            anchors.fill : parent;
            onClicked: RotationAnimation {
                target: rect;
                to: 90;
                duration: 1500;
                direction: RotationAnimation.Counterclockwise;
            }
        }
    }
    
    Rectangle {
        id: blueRect;
        color: "blue";
        width: 120;
        height: 60;
        anchors.right: parent.right;
        anchors.rightMargin: 40;
        anchors.verticalCenter: parent.verticalCenter;
        transformOrigin: Item.TopRight;
        
        MouseArea {
            anchors.fill : parent;
            onClicked: anim.start();
        }
        
        RotationAnimation {
            id: anim;
            target: blueRect;
            to: 60;
            duration: 1500;
        }
    }    
}
