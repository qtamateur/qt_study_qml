#ifndef COLORMAKER_H
#define COLORMAKER_H
#include <QObject>
#include <QColor>

/* 要想将一个类或者对象到处到QML中，下列条件必须满足（和使用信号和槽的条件一样！）：
 * 1.从QObject或QObject的派生类继承
 * 2.使用Q_OBJECT宏
 */
class ColorMaker : public QObject   //此类可以注册成一个QML类型供QML文档内建类型一样使用
{
    Q_OBJECT
/* 如果你要导出的类定义了想在QML中使用的枚举类型，可以使用Q_ENUMS宏将该枚举类型注册到元对象系统中！
 * 一旦注册了你的枚举类，在QML中就可以使用${CLASS_NAME}.${ENUM_VALUE}的形式来访问啦！
 */
    Q_ENUMS(GenerateAlgorithm)
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
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QColor timeColor READ timeColor)

public:
    ColorMaker(QObject *parent = 0);
    ~ColorMaker();

    enum GenerateAlgorithm{
        RandomRGB,
        RandomRed,
        RandomGreen,
        RandomBlue,
        LinearIncrease
    };

    QColor color() const;
    void setColor(const QColor & color);
    QColor timeColor() const;
/* 定义一个类的成员函数时使用下面的宏就可以让该方法被元对象系统调用，这个宏必须放在返回类型前面！
 * 一旦使用下面的宏将某个方法注册到元对象系统，在QML中就可以用${Object}.${method}来访问啦！！
 */
    Q_INVOKABLE GenerateAlgorithm algorithm() const;
    Q_INVOKABLE void setAlgorithm(GenerateAlgorithm algorithm);
/* 只要是信号和槽，都可以在QML中访问，你可以把C++对象的信号连接到QML中定义的方法上，也可以把QML对象的信号连接到C++对象的槽上，还可以直接调用C++
 * 对象的信号和槽！
 */
signals:
    void colorChanged(const QColor & color);
    void currentTime(const QString &strTime);

public slots:
    void start();
    void stop();

protected:
    void timerEvent(QTimerEvent *e);

private:
    GenerateAlgorithm m_algorithm;
    QColor m_currentColor;
    int m_nColorTimer;
};

#endif // COLORMAKER_H
