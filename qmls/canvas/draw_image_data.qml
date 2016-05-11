//加载CanvasImageData对象
import QtQuick 2.2

Rectangle {
    width: 480;
    height: 400;
    id: root;
    Canvas {
        id: randomImageData;
        width: 120;
        height: 100;
        contextType: "2d";
        property var imageData: null;
        onPaint: {
            if(imageData == null){
                imageData = context.createImageData(120, 100);  //Creates a CanvasImageData object with the given dimensions(120, 100).
                for(var i = 0; i < 48000; i += 4){
                    imageData.data[i] = Math.floor(Math.random() * 255);
                    imageData.data[i+1] = Math.floor(Math.random() * 255);
                    imageData.data[i+2] = Math.floor(Math.random() * 255);
                    imageData.data[i+3] = 255;
                }            
            }
            context.drawImage(imageData, 0, 0);
        }
    }
    
    Canvas {
        id: imageCanvas;
        property var poster: "http://p.qq181.com/cms/1210/2012100413195471481.jpg";
        anchors.left: parent.left;
        anchors.top: randomImageData.bottom;
        anchors.topMargin: 20;
        width: 200;
        height: 230;
        
        onPaint: {
            var ctx = getContext("2d");
            ctx.drawImage(poster, 0, 0, width, height);  //在左上角绘制width宽、height高的图片，会自动拉伸的！
        }
        Component.onCompleted: loadImage(poster);    //该方法会异步加载图片，加载完成后会发送imageLoaded信号
        onImageLoaded: {
            requestPaint();
            negative.setImageData(getContext("2d").createImageData(poster));
        }
    }
    
    Canvas {
        id: negative;
        anchors.left: imageCanvas.right;
        anchors.leftMargin: 10;
        anchors.top: imageCanvas.top;
        width: 200;
        height: 230;
        contextType: "2d";
        property var imageData: null;
        onPaint: {
            if(imageData != null){
                context.drawImage(imageData, 0, 0, width, height);
            }
        }
        
        function setImageData(data){   //对数据做底片特效处理
            imageData = data;
            var limit = data.width * data.height * 4;
            for(var i = 0; i < limit; i += 4){
                imageData.data[i] = 255 - data.data[i];
                imageData.data[i+1] = 255 - data.data[i+1];
                imageData.data[i+2] = 255 - data.data[i+2];
                imageData.data[i+3] = data.data[i+3];
            }
            requestPaint(); //这里处理完重绘了！！！没注意这里看了好久才发现！！！！
        }
    }
}
