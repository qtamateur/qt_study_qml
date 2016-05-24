#ifndef POINTSIZETOPIXELSIZE_H
#define POINTSIZETOPIXELSIZE_H
#include <QObject>

/* 这个类专门测算在使用指定pointSize的字体时字体的像素大小、字体的高度、文本的宽度等数据
 * 这个类被到出为QML属性fontUtil，在qml文件中使用！
 */

class PointSizeToPixelSize : public QObject
{
    Q_OBJECT
public:
    PointSizeToPixelSize(QObject *parent = 0){}
    ~PointSizeToPixelSize(){}

    Q_INVOKABLE int pixelSize(int pointSize);
    Q_INVOKABLE int height(int pointSize);
    Q_INVOKABLE int width(int pointSize, QString text);
};

#endif // POINTSIZETOPIXELSIZE_H
