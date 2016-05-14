//State的使用！Item有一个state属性，字符串类型，默认空。其还有一个states属性类型list<State>
/* State类型对应QQuickState，它属性有：
 * 1.name，字符串，保存状态名字
 * 2.when，布尔值，描述状态什么时候应用，应该绑定到ECMAScript上，当表达式返回true是应用本状态
 * 3.extend，字符串，指向当前状态的“基态”的名字，类似于C++中的“基类”
 * 4.changes，类型list<Change>，一个列表，保存应用这种状态的所有变化。 Change对应QQuickStateOperation
 * 注意：当进入一个状态时，第4条列表中的Change对象会顺序执行！
 */
import QtQuick 2.2

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
        
        MouseArea {
            id: mouseArea;
            anchors.fill : parent;
            onReleased: {
                centerText.state = "redText";
            }
        }        
        
        states: [     
            State { 
                name: "redText"; 
                changes:[
                    PropertyChanges{ target: centerText; color: "red"; }
                ]
            },
            State {
                name: "blueText";
                when: mouseArea.pressed;
                PropertyChanges{ target: centerText; color: "blue"; font.bold: true; font.pixelSize: 32; }
            }
        ]
        
        state: "redText";
        
        Component.onCompleted: {
            console.log("states - ", centerText.states.length);
            console.log("State - ", centerText.states[0]);
            console.log("changes - ", centerText.states[0].changes.length);
            console.log("Change - ", centerText.states[0].changes[0]);
        }
        
    }
}
