//PathView沿着特定路径显示Model内的数据。Model可以是QML内建的ListModel、XmlListModel，也可用C++实现QAbstractListModel的派生类
//简单学习Path，其是PathView的特有属性，指定PathView来放置Item的路径
//本例子代表二次贝塞尔曲线的样子，Path实际上看不到，此例子让大家有形象的认识！
import QtQuick 2.2

Canvas {
    width: 320;
    height: 240;

    onPaint: {
        var ctx = getContext("2d");
        ctx.lineWidth = 2;
        ctx.strokeStyle = "red";
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.quadraticCurveTo(0, height - 1, width - 1, height - 1);
        ctx.stroke();
    }
    
    Text {
        anchors.centerIn: parent;
        font.pixelSize: 20;
        text: "quadratic Bezier curve";
    }
}
