//PathView沿着特定路径显示Model内的数据。Model可以是QML内建的ListModel、XmlListModel，也可用C++实现QAbstractListModel的派生类
//简单学习Path，其是PathView的特有属性，指定PathView来放置Item的路径
//本例子代表卡特姆曲线的样子，Path实际上看不到，此例子让大家有形象的认识！
import QtQuick 2.2

Canvas {
    width: 400;
    height: 200;
    contextType: "2d";

    Path {
        id: myPath;
        startX: 4; 
        startY: 100;

        PathCurve { x: 75; y: 75; }
        PathCurve { x: 200; y: 150; }
        PathCurve { x: 325; y: 25; }
        PathCurve { x: 394; y: 100; }
    }

    onPaint: {
        context.strokeStyle = Qt.rgba(.4,.6,.8);
        context.path = myPath;
        context.stroke();
        context.strokeStyle = "green";
        context.fillRect(2, 98, 4, 4);
        context.fillRect(73, 73, 4, 4);
        context.fillRect(198, 148, 4, 4);
        context.fillRect(323, 23, 4, 4);
        context.fillRect(392, 98, 4, 4);
    }
}
