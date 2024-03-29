//学习CheckBox的使用！
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    width: 320;
    height: 300;
    color: "#d0d0d0";
    
    Rectangle {
        id: resultHolder;
        color: "#a0a0a0";
        width: 220;
        height: 80;
        anchors.centerIn: parent;
        visible: false;
        z: 2;
        opacity: 0.8;
        border.width: 2;
        border.color: "#808080";
        radius: 8;
        Text {
            id: result;
            anchors.fill: parent;
            anchors.margins: 5;
            font.pointSize: 16;
            color: "blue";
            font.bold: true;
            wrapMode: Text.Wrap;
        }
    }
    
    Component {
        id: checkStyle;
        CheckBoxStyle {    //定制CheckBox风格
            indicator: Rectangle {
                implicitWidth: 14;
                implicitHeight: 14;
                border.color: control.hovered ? "red" : "gray";
                border.width: control.hovered ? 3 : 1;
                Canvas {
                    anchors.fill: parent;
                    anchors.margins: 3;
                    visible: control.checked;
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.save();
                        ctx.strokeStyle = "#C00020";
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(width, height);
                        ctx.moveTo(0, height);
                        ctx.lineTo(width, 0);
                        ctx.stroke();
                        ctx.restore();
                    }
                }
            }        
            label: Text {
                color: control.checked ? "blue" : "black";
                text: control.text;
            }
        }
    }

    Text {
        id: notation;
        text: "Please select the best love movies:"
        anchors.top: parent.top;
        anchors.topMargin: 16;
        anchors.left: parent.left;
        anchors.leftMargin: 8;
    }
    Column {
        id: movies;
        anchors.top: notation.bottom;
        anchors.topMargin: 8;
        anchors.left: notation.left;
        anchors.leftMargin: 20;
        spacing: 8;
        CheckBox {
            text: "廊桥遗梦";
            style: checkStyle;
            onClicked: resultHolder.visible = false;
        }
        CheckBox {
            text: "人鬼情未了";
            style: checkStyle;
            onClicked: resultHolder.visible = false;
        }
        CheckBox {
            text: "触不到的恋人";
            style: checkStyle;
            onClicked: resultHolder.visible = false;
        }
        CheckBox {
            text: "西雅图夜未眠";
            style: checkStyle;
            onClicked: resultHolder.visible = false;
        }
    }        
    
    Button {
        id: confirm;
        text: "Confirm";
        anchors.top: movies.bottom;
        anchors.topMargin: 8;
        anchors.left: notation.left;   
        onClicked: {
            var str = new Array();
            var index = 0;
            var count = movies.children.length;
            for(var i = 0; i < count; i++){
                if(movies.children[i].checked){
                    str[index] = movies.children[i].text;
                    index++;
                }    
            }
            if(index > 0){
                result.text = str.join();  //join()方法是一个非常实用的方法，它把当前Array的每个元素都用指定的字符串连接起来，然后返回连接后的字符串
                resultHolder.visible = true;
            }
        }
    }
}
