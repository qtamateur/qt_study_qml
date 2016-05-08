//布局管理器————GridLayout
/*布局管理器与定位器最大的不同在于其所管理的Item可以使用下列附件属性：
 *Layout.row  Layout.column  Layout.rowSpan Layout.columnSpan Layout.minimumWidth Layout.minimumHeight
 *Layout.preferredHeight Layout.preferredWidth Layout.maximumHeight Layout.maximumWidth
 *Layout.fillHeight Layout.fillWidth Layout.alignment
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1   //布局管理器需要引入Layout模块

Rectangle {
    width: 360;
    height: 240;
    color: "#EEEEEE";
    id: rootItem;
    
    Text {
        id: centerText;
        text: "A Single Text.";
        anchors.centerIn: parent;
        font.pixelSize: 24;
        font.bold: true;
    }
    
    function setTextColor(clr){
        centerText.color = clr;
    }
    
    GridLayout {
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 4;
        width: 300;
        rows: 3;
        columns: 3;
        rowSpacing: 4;
        columnSpacing: 4;
        flow: GridLayout.TopToBottom;
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);
            Layout.columnSpan: 3;   //占用三行，实际没有起作用，下面一行代码把本行代码覆盖了。说明一次只能占用三行或者三列！！
            Layout.rowSpan: 3;      //占用三列
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);     
            onColorPicked: setTextColor(clr);
            Layout.fillWidth: true;
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);     
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);     
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);     
        }
        
        ColorPicker {
            color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1.0);
            onColorPicked: setTextColor(clr);     
        }        
    }
}
