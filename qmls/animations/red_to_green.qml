//学习ColorAnimation，其是PropertyAnimation的派生类！专门处理color类型的property
import QtQuick 2.2

Rectangle {
    width: 320;
    height: 240;
    color: "#EEEEEE";
    
    Rectangle {
        id: rect;
        color: "red";
        width: 60;
        height: 60;
        radius: 30;
        anchors.centerIn: parent;
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
            onClicked: ColorAnimation {
                target: rect;
                property: "color";
                to: "green";
                duration: 1500;
            }
        }
    }
}
