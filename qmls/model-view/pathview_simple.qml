//PathView沿着特定路径显示Model内的数据。Model可以是QML内建的ListModel、XmlListModel，也可用C++实现QAbstractListModel的派生类
/* 像 ListView 一样，PathView 有一个count属性，保存 PathView 要显示的 item 总数。另外 PathView 还有一个 pathItemCount 属性，
 * 指定在路径上可见的 item 数量，它可以与 count 不同。
 * preferredHighlightBegin 和 preferredHighlightEnd 属性的值是 real 类型的，范围0.0至1.0。preferredHighlightBegin 指定
 * 当前 item 在 view 中的首选起始位置， preferredHighlightEnd 指定当前 item 在 view 中的首选结束位置。与它们相关的，还有一个
 * highlightRangeMode属性，可以取值 PathView.NoHighlightRange、PathView.ApplyRange或PathView.StrictlyEnforceRange
 * 比如我们想严格地将当前 item 限制在路径的中央，可以设置 highlightRangeMode 为 PathView.StrictlyEnforceRange，设置
 * preferredHighlightBegin 和 preferredHighlightEnd 都为 0.5
 * highlight 属性指定为当前 item 绘制高亮效果的组件。
 * PathView 像 Flickable 一样，当用户拖动 view 时，具有弹簧效果。 interactive 属性设置为 true ，用户就可以拖动 PathView ，如果
 * 产生了弹动， flicking 会变为 true 。 flickDeceleration 属性设置弹簧效果的衰减速率，默认值为 100 。
 * decrementCurrentIndex()、incrementCurrentIndex() 两个方法可以递减、递增 PathView 维护的当前 item 的索引。
 * 这两个函数有循环效果，如果你不需要，可以自己修改 currentIndex 属性来实现你的逻辑。
 * PathView 还向delegate导出了 isCurrentItem(布尔值) 、onPath(布尔值) 、 view 三个附加属性。在 delegate 的顶层 item 内使用
 * PathView.isCurrentItem 可以获知本 item 是否为 PathView 的当前 item ；使用 PathView.onPath 则可以知道本 item 是否在路径上；
 * PathView.view则指向 item 所属的 PathView 实例，你可以通过它来访问 PathView 的方法、属性、信号等。
 */
import QtQuick 2.2

Rectangle {
    width: 480;
    height: 300;
    color: "black";
    id: root;
/* 我定义了一个很简单的 delegate ：在带边框的矩形内显示 item 索引。 delegate 的顶层 item 使用了路径内通过 PathAttribute 定义的
 * zOrder 、itemAlpha 、 itemScale 等附加属性来控制 item 的大小、透明度。 Rectangle 对象的颜色随机生成。边框则通过
 * isCurrentItem 附加属性来分别设置，注意附加属性只在顶层 item ，即 wrapper 内可以直接访问，所以 Rectangle 内使用
 * wrapper.PathView.isCurrentItem 来访问。
 */
    Component {
        id: rectDelegate;
        Item {
            id: wrapper;
            z: PathView.zOrder;
            opacity: PathView.itemAlpha;
            scale: PathView.itemScale;
            Rectangle {
                //anchors.centerIn: parent;
                width: 100;
                height: 60;
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
                border.width: 2;
                border.color: wrapper.PathView.isCurrentItem ? "red" : "lightgray";
                Text {
                    anchors.centerIn: parent;
                    font.pixelSize: 28;
                    text: index;
                    color: Qt.lighter(parent.color, 2);
                }
                MouseArea {
                    anchors.fill: parent;
                    onClicked: {
                        wrapper.PathView.view.currentIndex = index;
                    }
                }                
            }            
        }
    }
    
    PathView {
        id: pathView;
        anchors.fill: parent;
        interactive: true;
        pathItemCount: 7;
        // keep highlight sit on the middle of Path
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        highlightRangeMode: PathView.StrictlyEnforceRange;
        //snapMode: PathView.SnapToItem;
        snapMode: PathView.SnapOneItem;

        delegate: rectDelegate;
        model: 15;

        path:Path {
            startX: 10; 
            startY: 100;
            PathAttribute { name: "zOrder"; value: 0; }
            PathAttribute { name: "itemAlpha"; value: 0.1; }
            PathAttribute { name: "itemScale"; value: 0.6; }
            PathLine {
                x: root.width/2 - 40;
                y: 100;
            }         
            PathAttribute { name: "zOrder"; value: 10; } 
            PathAttribute { name: "itemAlpha"; value: 0.8; }  
            PathAttribute { name: "itemScale"; value: 1.2; }
            //PathPercent { value: 0.28; }
            PathLine {
                //x: root.width - 100;
                //y: 100;
                relativeX: root.width/2 - 60;
                relativeY: 0;
            }
            PathAttribute { name: "zOrder"; value: 0; }                            
            PathAttribute { name: "itemAlpha"; value: 0.1; }
            PathAttribute { name: "itemScale"; value: 0.6; }
        }

        focus: true;   // focus设置为true,是为了处理按键事件。左右方向键可以循环浏览PathView内的item。
        Keys.onLeftPressed: decrementCurrentIndex();
        Keys.onRightPressed: incrementCurrentIndex();
    }
}
