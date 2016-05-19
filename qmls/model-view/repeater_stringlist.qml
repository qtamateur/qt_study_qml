/* Repeater是一个特别、好用的类，创建基于Item的组件，扔给它的父(通常是定位器或布局管理器)来管理，这时其与ListView的显著不同！
 * 即：ListView又生娃又养娃，Repeater只生不养！
 * Repeater有三个属性：count指示它创建了多少个基于Item的对象、model指定数据模型、delegate是待实例化的组件。delegate是默认属性，在定义
 * Repeater对象时通常不显式初始化
 * itemAt(index)方法根据索引返回对应的delegate实例
 * 注意：Repeater实例化后一次性创建由model决定的所有Item，如果你对此敏感，可以使用ListView，其创建Item是渐进式，需要显示才创建
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1

//model属性可以取：1.数字 2.字符串列表 3.对象列表 4.ListModel等常见的model
//本例演示model为字符串列表！

Rectangle {
    width: 300;
    height: 200;
    color: "#EEEEEE";

    Row {
        anchors.centerIn: parent;
        spacing: 8;
        Repeater {
            model: ["Hello", "Qt", "Quick"];
            Text {
                color: "blue";
                font.pointSize: 18;
                font.bold: true;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                text: modelData;
            }
        }
    }
}
