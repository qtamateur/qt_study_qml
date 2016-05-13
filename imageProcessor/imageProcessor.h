#ifndef IMAGEPROCESSOR_H
#define IMAGEPROCESSOR_H
#include <QObject>
#include <QString>

class ImageProcessorPrivate;
class ImageProcessor : public QObject
{
    Q_OBJECT
/* 如果你要导出的类定义了想在QML中使用的枚举类型，可以使用Q_ENUMS宏将该枚举类型注册到元对象系统中！
 * 一旦注册了你的枚举类，在QML中就可以使用${CLASS_NAME}.${ENUM_VALUE}的形式来访问啦！
 */
    Q_ENUMS(ImageAlgorithm)
/* Q_PROPERTY宏用来定义可通过元对象系统访问的属性，通过它定义的属性，可以在QML中访问、修改，也可用在属性变化时发出特定的信号！其原型如下：
 * Q_PROPERTY(type name
       (READ getFunction [WRITE setFunction] |
        MEMBER memberName [(READ getFunction | WRITE setFunction)])
       [RESET resetFunction]
       [NOTIFY notifySignal]
       [REVISION int]
       [DESIGNABLE bool]
       [SCRIPTABLE bool]
       [STORED bool]
       [USER bool]
       [CONSTANT]
       [FINAL])
 * type name: 即类型名＋属性名
 * READ: 设置读取成员变量的函数名，一般要是const、没有参数、返回定义的属性！READ是必须的，而write, reset等则是可选的，且只有READ的属性为只读属性
 * WRITE: 写成员变量的函数名，返回值必须是void，且只能有一个与属性类型匹配的参数
 * NOTIFY：给属性关联一个信号(该信号必须是已经在类中声明过的)，当属性值发生变化时就会触发该信号。信号的参数一般就是你定义的属性！
 * 如下面定义了类型是QColor，名字为color的属性，通过color()方法来访问，通过setColor(const QColor & color)方法来写入，属性变化时触发colorChanged(const QColor & color)信号
 */
    Q_PROPERTY(QString sourceFile READ sourceFile)
    Q_PROPERTY(ImageAlgorithm algorithm READ algorithm)

public:
    ImageProcessor(QObject *parent = 0);
    ~ImageProcessor();
    //枚举类第一个默认为0，这里主动赋值0貌似没什么作用
    enum ImageAlgorithm{
        Gray = 0,
        Binarize,
        Negative,
        Emboss,
        Sharpen,
        Soften,
        AlgorithmCount
    };

    QString sourceFile() const;
    ImageAlgorithm algorithm() const;
    void setTempPath(QString tempPath);   //设置临时目录

signals:
    void finished(QString newFile);   //次信号通知关注着图像处理完毕
    void progress(int value);   //此方法供客户程序调用

public slots:
    void process(QString file, ImageAlgorithm algorithm);
    void abort(QString file, ImageAlgorithm algorithm);
    void abortAll();

private:
    ImageProcessorPrivate *m_d;
};

#endif // IMAGEPROCESSOR_H
