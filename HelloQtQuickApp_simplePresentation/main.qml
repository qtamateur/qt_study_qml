/*QML文档由两部分组成：
 *1.import语句     2.QML对象树
 */
import QtQuick 2.2   //导入2.2版本的QtQuick模块，包括ji基本的QML类型，如：Text、Rectangle、Item、Row等
import QtQuick.Window 2.1  //包含Window类型，代表QML顶层窗口，对应C++类型的QQuickWindow
/*QML的默认属性指：没有显示使用“proerty：value”形式初始化的对象。
 *如：Window的默认属性是data，即list<Object>类型的列表，如果其内部声明其他未显示赋值的对象，如Text，则其被存入data列表中
 *注意：除了Window及其派生类外，QML中其他可见元素大多是Item的派生类，Item默认属性也是list<Object>类型的data！因此Item及其派生类也可做QML
 *文档的根对象，这时可用QQuickView（QQuickWindow的派生类）来加载QML文档。 总结见main.cpp文件。
 */
Window {
    visible: true
    width: 360
    height: 360
    contentOrientation: Qt.PortraitOrientation
    //visibility: Window.Windowed

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    Text {
        text: qsTr("Hello Qt Quick App")
        anchors.centerIn: parent
    }
}
