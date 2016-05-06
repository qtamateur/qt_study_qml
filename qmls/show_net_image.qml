//学习如何显示网络上的图片
import QtQuick 2.2
import QtQuick.Controls 1.2

Rectangle {
    width: 480;
    height: 320;
    color: "#121212";

    BusyIndicator {   //用来显示一个等待图元，缓解用户的焦躁情绪
        id: busy;
        running: true;    //这个值为ture则显示，style属性定制显示内容，默认为本例的圆圈！
        anchors.centerIn: parent;
        z: 2;
    }

    Text {
        id: stateLabel;
        visible: false;
        anchors.centerIn: parent;
        z: 3;
    }

    Image {
        id: imageViewer;
        asynchronous: true;  //对本地图片才有效的异步加载。注意：加载网络图片不用设置，默认就是异步
        cache: false;    //不用缓存图片
        anchors.fill: parent;
        fillMode: Image.PreserveAspectFit;  //the image is scaled uniformly to fit without cropping
        onStatusChanged: {
            if (imageViewer.status === Image.Loading) {
                busy.running = true;
                stateLabel.visible = false;
            }
            else if(imageViewer.status === Image.Ready){
                busy.running = false;
            }
            else if(imageViewer.status === Image.Error){
                busy.running = false;
                stateLabel.visible = true;
                stateLabel.text = "ERROR";
            }
        }
    }

    Component.onCompleted: {
        imageViewer.source = "http://image.cuncunle.com/Images/EditorImages/2013/01/01/19/20130001194920468.JPG";
    }
}
