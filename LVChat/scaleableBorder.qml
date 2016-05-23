//本例讲解BorderImage的用法，类似Android框架的9patch图片！
//一般只要设置source和border即可，详细查询帮助文档，很清楚！
import QtQuick 2.2

Rectangle {
    width: 450;
    height: 300;

    Row{
        anchors.centerIn: parent;
        BorderImage{
            width: 130;
            height: 200;
            border.left: 16;
            border.top: 38;
            border.right: 6;
            border.bottom: 6;
            source: "res/chat_from_bg_normal.9.png";
        }
        BorderImage{
            width: 200;
            height: 150;
            border.left: 16;
            border.top: 38;
            border.right: 6;
            border.bottom: 6;
            source: "res/chat_from_bg_normal.9.png";
        }        
        BorderImage{
            width: 100;
            height: 280;
            border.left: 16;
            border.top: 38;
            border.right: 6;
            border.bottom: 6;
            source: "res/chat_from_bg_normal.9.png";
        }           
    }
}
