import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtMultimedia 5.0

/* ApplicationWindow有菜单栏(menuBar属性）、工具栏（toolBar属性）、状态栏（statusBar属性）。咦，没有centralWidget哈，
 * 别急，有的，就是ContentItem，就是那个你不与任何属性绑定的Item。
 */

ApplicationWindow {
    visible: true
    width: 480
    height: 360;
    color: "black";
    title: "文件查看器";
    id: root;
    property var aboutDlg: null;
    property var colorDlg: null;
    property color textColor: "green";
    property color textBackgroundColor: "black";
/* MenuBar:
 * 就是菜单栏一长条区域了，它干两件事：
 * 1.维护一个Menu列表（menus属性）
 * 2.绘制菜单栏背景色（style属性）
 * Memu:
 * 看截图中的“文件”、“设置”、“帮助”三个菜单，点一下弹出一个子菜单，Menu就代表文件这个菜单和它下面的子菜单。
 * 列表属性items指向Menu的子菜单项，它的类型是list<Object>，是默认属性。
 * title属性是string类型，你看到的“文件”、“设置”等字样就是它指定的。
 * 有这两个属性，Menu就可以开始干活了。
 * MenuItem:
 * Menu的孩子啊，最受待见的就是MenuItem了。
 * MenuItem代表一个具体的菜单项，点一下就干一件事情的角色。你可以实现onTriggered信号处理响应用户对它的选择。
 * MenuItem的text属性指定菜单文字，iconSource属性指定菜单图标。
 * Action属性很强大哦，MenuItem的text、iconSource、trigger信号等实现的效果，都可以通过Action来实现，这两种方式是等同的。
 * 咱们来看Action:
 * Action类有text、iconSource等属性，还有toggled、triggered两个信号。这些在MenuItem里有对应的属性，不必多说了。
 * 使用Action的一大好处是，你可以给它指定一个id（比如叫open），然后在使用ToolButton构造ToolBar时指定ToolBatton的action属性为之前
 * 定义的id为open的那个action，这样工具栏的按钮就和菜单关联起来了。
 */
    menuBar: MenuBar{
        Menu {
            title: "文件";
            MenuItem{
                iconSource: "res/txtFile.png";
                action: Action{
                    id: textAction;
                    iconSource: "res/txtFile.png";
                    text: "文本文件";
                    onTriggered: {
                        fileDialog.selectedNameFilter = fileDialog.nameFilters[0];
                        fileDialog.open();
                    }
                    tooltip: "打开txt等文本文件";
                }
            }
            MenuItem{
                action: Action {
                    id: imageAction;
                    text: "图片";
                    iconSource: "res/imageFile.png";
                    onTriggered: {
                        fileDialog.selectedNameFilter = fileDialog.nameFilters[1];
                        fileDialog.open();
                    }
                    tooltip: "打开jpg等格式的图片";
                }
            }
            MenuItem{
                action: Action {
                    id: videoAction;
                    iconSource: "res/videoFile.png";
                    text: "视频";
                    onTriggered: {
                        fileDialog.selectedNameFilter = fileDialog.nameFilters[2];
                        fileDialog.open();
                    }
                    tooltip: "打开TS、MKV、MP4等格式的文件";
                }
            }
            MenuItem{
                action: Action {
                    id: audioAction;
                    iconSource: "res/audioFile.png";
                    text: "音乐";
                    onTriggered: {
                        fileDialog.selectedNameFilter = fileDialog.nameFilters[3];
                        fileDialog.open();
                    }
                    tooltip: "打开mp3、wma等格式的文件";
                }
            }
            MenuItem{
                text: "退出";
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: "设置";
            MenuItem {
                action: Action {
                    id: textColorAction;
                    iconSource: "res/ic_textcolor.png";
                    text: "文字颜色";
                    onTriggered: root.selectColor(root.onTextColorSelected);
                }
            }
            MenuItem {
                action: Action{
                    id: backgroundColorAction;
                    iconSource: "res/ic_bkgndcolor.png";
                    text: "文字背景色";
                    onTriggered: root.selectColor(root.onTextBackgroundColorSelected);
                }
            }
            MenuItem {
                action: Action{
                    id: fontSizeAddAction;
                    iconSource: "res/ic_fontsize2.png";
                    text: "增大字体";
                    onTriggered: textView.font.pointSize += 1;
                }
            }
            MenuItem {
                action: Action{
                    id: fontSizeMinusAction;
                    iconSource: "res/ic_fontsize1.png";
                    text: "减小字体";
                    onTriggered: textView.font.pointSize -= 1;
                }
            }
        }
        Menu {
            title: "帮助";
            MenuItem{
                text: "关于";
                onTriggered: root.showAbout();
            }
            MenuItem{
                text: "访问作者博客";
                onTriggered: Qt.openUrlExternally("http://blog.csdn.net/foruok");
            }
        }
    }
/* ToolBar:
 * ToolBar就是工具栏对应的类，它只有一个属性，contentItem，类型为Item。一般我们可以将一个Row或者RowLayout对象赋值给contentItem，
 * 而Row或RowLayout则管理一组ToolButton来作为工具栏上的按钮。
 * ToolButton:
 * ToolButton是Button的派生类，专为ToolBar而生，一般情况下定义ToolButton对象时只需要指定其iconSource属性即可。
 * 还有一种方式是将一个已定义好的Action对象关联到ToolButton对象上。这样的话，ToolButton会使用Action定义的iconSource或iconName
 * 作为其图标。
 */
    toolBar: ToolBar{
        RowLayout {
            ToolButton{
                action: textAction;
            }
            ToolButton{
                action: imageAction;
            }
            ToolButton{
                action: videoAction;
            }
            ToolButton{
                action: audioAction;
            }
            ToolButton{
                action: textColorAction;
            }
            ToolButton {
                action: backgroundColorAction;
            }
            ToolButton {
                action: fontSizeAddAction;
            }
            ToolButton {
                action: fontSizeMinusAction;
            }
        }
    }
/* 状态栏:
 * ApplicationWindow的属性statusBar代表状态栏，其类型为Item，你可以将任意的Item赋值给它，可以随心所欲构建你妖娆多姿的状态栏。
 */
    statusBar: Rectangle {
        color: "lightgray";
        implicitHeight: 30;
        width: parent.width;
        property alias text: status.text;
        Text {
            id: status;
            anchors.fill: parent;
            anchors.margins: 4;
            font.pointSize: 12;
        }
    }

    Item {
        id: centralView;
        anchors.fill: parent;
        visible: true;
        property var current: null;
        BusyIndicator {
            id: busy;
            anchors.centerIn: parent;
            running: false;
            z: 3;
        }
        Image {
            id: imageViewer;
            anchors.fill: parent;
            visible: false;
            asynchronous: true;
            fillMode: Image.PreserveAspectFit;
            onStatusChanged: {
                if (status === Image.Loading) {
                    centralView.busy.running = true;
                }
                else if(status === Image.Ready){
                    centralView.busy.running = false;
                }
                else if(status === Image.Error){
                    centralView.busy.running = false;
                    centralView.statusBar.text = "图片无法显示";
                }
            }
        }
/* TextArea:
 * 这有什么好讲的，看Qt帮助吧。只提一点：
 * TextArea自动处理翻页按键、上下键、鼠标中键，正确的滚动文本；而TextEdit，抱歉，我是来打酱油的。
 */
        TextArea {
            id: textView;
            anchors.fill: parent;
            readOnly: true;
            visible: false;
            wrapMode: TextEdit.WordWrap;
            font.pointSize: 12;
            style: TextAreaStyle{
                backgroundColor: root.textBackgroundColor;
                textColor: root.textColor;
                selectionColor: "steelblue";
                selectedTextColor: "#a00000";
            }

            property var xmlhttp: null;
            function onReadyStateChanged(){
                if(xmlhttp.readyState == 4){
                    text = xmlhttp.responseText;
                    xmlhttp.abort();
                }
            }
/* XMLHttpRequest:
 * 在Qt Quick里，要访问网络肿么办泥？答案是：XMLHttpRequest ！
 * 不要被它傲娇的外表迷惑，以为它只接受XML文档，其实，它什么都能处理，txt、html、json、binary……它温柔坚定强悍无比。
 * 本实例用它来加载本地的文本文件，耶，这样都可以哈。谁叫Qt Quick不提供直接访问本地文件的类库呢！我可不想跑到C++里用QFile、QTextStream这对黄金搭档。
 * XMLHttpRequest的文档，Qt帮助里语焉不详，只有一个示例，请看这里：
 *  http://www.w3school.com.cn/xml/xml_http.asp
 */
            function loadText(fileUrl){
                if(xmlhttp == null){
                    xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = onReadyStateChanged;
                }
                if(xmlhttp.readyState == 0){
                    xmlhttp.open("GET", fileUrl);
                    xmlhttp.send(null);
                }
            }
        }

        VideoOutput {
            id: videoOutput;
            anchors.fill: parent;
            visible: false;
            source: player;
            onVisibleChanged: {
                playerState.visible = visible;
                if(visible == false){
                    player.stop();
                }
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    switch(player.playbackState){
                    case MediaPlayer.PausedState:
                    case MediaPlayer.StoppedState:
                        player.play();
                        break;
                    case MediaPlayer.PlayingState:
                        player.pause();
                        break;
                    }
                }
            }
        }

        Rectangle {
            id: playerState;
            color: "gray";
            radius: 16;
            opacity: 0.8;
            visible: false;
            z: 2;
            implicitHeight: 80;
            implicitWidth: 200;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.bottom: parent.bottom;
            anchors.bottomMargin: 16;
            Column {
                anchors.fill: parent;
                anchors.leftMargin: 12;
                anchors.rightMargin: 12;
                anchors.topMargin: 6;
                anchors.bottomMargin: 6;
                spacing: 4;
                Text {
                    id: state;
                    font.pointSize: 14;
                    color: "blue";
                }
                Text {
                    id: progress;
                    font.pointSize: 12;
                    color: "white";
                }
            }
        }
/* MediaPlayer:
 * Qt Quick里，播放视频、音频文件都直接使用MediaPlayer类，它是万能的，不要说你万万没想到哈。
 * 对于音乐，最简单，设置source属性，调用play()方法，就可以了。
 * 对于视频，MediaPlayer还得寻求场外帮助，求助对象就是它的好基友：VideoOutput ！
 */
        MediaPlayer {
            id: player;

            property var utilDate: new Date();
            function msecs2String(msecs){
                utilDate.setTime(msecs);
                return Qt.formatTime(utilDate, "mm:ss");
            }
            property var sDuration;

            onPositionChanged: {
                progress.text = msecs2String(position) + sDuration;
            }
            onDurationChanged: {
                sDuration = " / " + msecs2String(duration);
            }
            onPlaybackStateChanged: {
                switch(playbackState){
                case MediaPlayer.PlayingState:
                    state.text = "播放中";
                    break;
                case MediaPlayer.PausedState:
                    state.text = "已暂停";
                    break;
                case MediaPlayer.StoppedState:
                    state.text = "停止";
                    break;
                }
            }
            onStatusChanged: {
                switch(status){
                case MediaPlayer.Loading:
                case MediaPlayer.Buffering:
                    busy.running = true;
                    break;
                case MediaPlayer.InvalidMedia:
                    root.statusBar.text = "无法播放";
                case MediaPlayer.Buffered:
                case MediaPlayer.Loaded:
                    busy.running = false;
                    break;
                }
            }
        }
    }


    function processFile(fileUrl, ext){
        var i = 0;
        for(; i < fileDialog.nameFilters.length; i++){
            if(fileDialog.nameFilters[i].search(ext) != -1) break;
        }
        switch(i){
        case 0:
            //text file
            if(centralView.current != textView){
                if(centralView.current != null){
                    centralView.current.visible = false;
                }
                textView.visible = true;
                centralView.current = textView;
            }
            textView.loadText(fileUrl);
            break;
        case 1:
            if(centralView.current != imageViewer){
                if(centralView.current != null){
                    centralView.current.visible = false;
                }
                imageViewer.visible = true;
                centralView.current = imageViewer;
            }
            imageViewer.source = fileUrl;
            break;
        case 2:
        case 3:
            if(centralView.current != videoOutput){
                if(centralView.current != null){
                    centralView.current.visible = false;
                }
                videoOutput.visible = true;
                centralView.current = videoOutput;
            }
            player.source = fileUrl;
            player.play();
            break;
        default:
            statusBar.text = "抱歉，处理不了";
            break;
        }
    }

    function showAbout(){
        if(aboutDlg == null){
            aboutDlg = Qt.createQmlObject(
                        'import QtQuick 2.2;import QtQuick.Dialogs 1.1;MessageDialog{icon: StandardIcon.Information;title: "关于";\ntext: "仅仅是个示例撒";\nstandardButtons:StandardButton.Ok;}'
                        , root, "aboutDlg");
            aboutDlg.accepted.connect(onAboutDlgClosed);
            aboutDlg.rejected.connect(onAboutDlgClosed);
            aboutDlg.visible = true;
        }

    }

    function selectColor(func){
        if(colorDlg == null){
            colorDlg = Qt.createQmlObject(
                        'import QtQuick 2.2;import QtQuick.Dialogs 1.1;ColorDialog{}',
                        root, "colorDlg");
            colorDlg.accepted.connect(func);
            colorDlg.accepted.connect(onColorDlgClosed);
            colorDlg.rejected.connect(onColorDlgClosed);
            colorDlg.visible = true;
        }
    }

    function onAboutDlgClosed(){
        aboutDlg.destroy();
        aboutDlg = null;
    }

    function onColorDlgClosed(){
        colorDlg.destroy();
        colorDlg = null;
    }

    function onTextColorSelected(){
        root.textColor = colorDlg.color;
    }

    function onTextBackgroundColorSelected(){
        root.textBackgroundColor = colorDlg.color;
    }

    FileDialog {
        id: fileDialog;
        title: qsTr("Please choose an image file");
        nameFilters: [
            "Text Files (*.txt *.ini *.log *.c *.h *.java *.cpp *.html *.xml)",
            "Image Files (*.jpg *.png *.gif *.bmp *.ico)",
            "Video Files (*.ts *.mp4 *.avi *.flv *.mkv *.3gp)",
            "Audio Files (*.mp3 *.ogg *.wav *.wma *.ape *.ra)",
            "*.*"
        ];
        onAccepted: {
            var filepath = new String(fileUrl);
            //remove file:///
            if(Qt.platform.os == "windows"){
                root.statusBar.text = filepath.slice(8);
            }else{
                root.statusBar.text = filepath.slice(7);
            }
            var dot = filepath.lastIndexOf(".");
            var sep = filepath.lastIndexOf("/");
            if(dot > sep){
                var ext = filepath.substring(dot);
                root.processFile(fileUrl, ext.toLowerCase());
            }else{
                root.statusBar.text = "Not Supported!";
            }
        }
    }
}

/* 标准对话框:
    Qt Quick提供了很多标准对话框，比如FileDialog用来选择文件或文件夹，ColorDialog用来选择颜色，MessageDialog用来显示一些提示信息。这些我们实例中用到了，参考Qt帮助吧。
    我只说点儿经验。
    我一开始使用qmlscene来加载main.qml，出来的界面比较正常，工具栏的图标、菜单项前也有图标。可是当我创建了一个Qt Quick App，灵异事件发生了：
    菜单项前面没有图标了……
    工具栏图标好大好大……
    颜色对话框、消息框，点击右上角的关闭按钮，收不到rejected信号啊……
    查了老半天，猛回头，警世钟响起，我了悟了。原来是酱紫的：
    Qt Quick提供了这些标准对话框的默认实现，如果应用运行的平台没有可用的，就用这些默认实现。那在Windows上，如果你的main()函数，使用QGuiApplication而非QApplication，就会用到Qt Quick实现的版本，一切都变了模样
 */

/* 资源管理:
    Qt SDK 5.3之后，Qt Creator创建的Qt Quick App项目，就为我们建立了一个qrc文件，把main.qml扔里啦。我在实例中也把很多图标扔里了。
    使用qrc来管理资源，这是跨平台的，推荐使用。
    我还自己画了些图标，真费劲，弄得也不好看。不过应用的大眼睛图标，看起来还像那么一回事儿。
 */
