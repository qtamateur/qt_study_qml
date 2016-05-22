#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

/*  C++代码
    其实，我只对模板生成的C++代码改动了三行，一行include，一行QApplication，一行设置应用图标。
 */
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/res/eye.png"));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
