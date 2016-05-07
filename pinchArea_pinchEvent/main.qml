import QtQuick 2.0

Rectangle {
    width: 360;
    height: 360;
    focus: true;
    Rectangle {
        width: 100;
        height: 100;
        color: "blue";
        id: transformRect;
        anchors.centerIn: parent;
    }
    PinchArea {   //其是Item的派生类，代表捏拉手势，介绍其除了继承子Item类的两个专有属性：
        //1.enabled:默认true，设为false则PinchArea啥也不干了
        //2.pinch：描述捏拉手势的详情，是一个组合属性，包括许多属性，如下面的例子
        anchors.fill: parent
        pinch.maximumScale: 20;   //最大放缩系数
        pinch.minimumScale: 0.2;  //最小放缩系数
        pinch.minimumRotation: 0; //最小旋转角度
        pinch.maximumRotation: 90;//最大旋转角度
//        pinch.target: transformRect;  //这个属性设置捏拉手势要操作的Item，这里去掉了，就需要加上后面三个事件处理，否则可以不用自己处理后面三个信号！！
        //以下三个信号都有一个名为pinch的参数，类型是PinchEvent
        onPinchStarted: {
            pinch.accepted = true;  //accepted属性在onPinchStarted处理器中设为true表明你要响应PinchEvent，Qt会持续给你更新事件，否则Qt不再给你发送PinchEvent事件了
        }
        onPinchUpdated: {
            transformRect.scale *= pinch.scale; //scale表示两触点之间的放缩系数，previousScale是上一次事件的放缩系数
            transformRect.rotation += pinch.rotation; //angle两触点间角度，previousAngle上一次事件角度，rotatoin捏拉手势开始到当前事件的总旋转角度
        }
        onPinchFinished: {
            transformRect.scale *= pinch.scale;
            transformRect.rotation += pinch.rotation;
        }
        //此外pinch还有center代表两触点中心点，previousCenter上次事件中心点，startCenter事件开始时的中心点；point1，point2保存当前触点位置，startPoint1,startPoint2
        //保存第二个触点按下时两个触点的位置
    }
}

