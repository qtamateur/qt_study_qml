import QtQuick 2.2
import QtQuick.Window 2.1

Window {
    visible: true
    width: 360
    height: 360

    MultiPointTouchArea {  //本身是一个不可见的Item，可以放在其他Item内来跟踪多点触摸
        //继承子Item的enabled属性为true启动触摸处理，反正禁用；mouseEnabled为true则把鼠标当成一个触点，否则忽略鼠标事件
        anchors.fill: parent;
        touchPoints:[  //touchPoints是列表属性，保存用户定义的用于和Item绑定的触点
            TouchPoint{
                id: tp1;
            },
            TouchPoint{
                id: tp2;
            },
            TouchPoint{
                id: tp3;
            }

        ]
    }

    Image {
        source: "ic_qt.png";
        x: tp1.x;
        y: tp1.y;
    }

    Image {
        source: "ic_android.png";
        x: tp2.x;
        y: tp2.y;
    }

    Image {
        source: "ic_android_usb.png";
        x: tp3.x;
        y: tp3.y;
    }
}
