#include "imageProcessor.h"
#include <QThreadPool>
#include <QList>
#include <QFile>
#include <QFileInfo>
#include <QRunnable>
#include <QEvent>
#include <QCoreApplication>
#include <QPointer>
#include <QUrl>
#include <QImage>
#include <QDebug>
#include <QDir>
#include <QUrl>

typedef void (*AlgorithmFunction)(QString sourceFile, QString destFile);  //显示声明一个函数指针！
//算法函数放在一个全局的函数指针数组中，下面的类则根据算法枚举值从数组中取出相应的函数来处理图像
class AlgorithmRunnable;
class ExcutedEvent : public QEvent
{
public:
    ExcutedEvent(AlgorithmRunnable *r)
        : QEvent(evType()), m_runnable(r)
    {

    }
    AlgorithmRunnable *m_runnable;

    static QEvent::Type evType()
    {
        if(s_evType == QEvent::None)  //这个判断很有用，解释在下面一个注释里面！
        {
            s_evType = (QEvent::Type)registerEventType();
        }
        return s_evType;
    }

private:
    static QEvent::Type s_evType;
};
QEvent::Type ExcutedEvent::s_evType = QEvent::None;  //一开始把需要注册的事件赋值为None，在返回事件类型的函数里面就不会多次注册了！！

/* 把图像变灰，大概有这么三种方法：
 * 1.最大值法，即 R = G = B = max(R , G , B)，这种方法处理过的图片亮度偏高
 * 2.平均值法，即 R = G = B = (R + G + B) / 3 ，这种方法处理过的图片比较柔和
 * 3.加权平均值法，即 R = G = B = R*Wr + G*Wg + B*Wb ，因为人眼对不同颜色的敏感度不一样，三种颜色权重也不一样，一般来说绿色最高，红色次之，蓝色最低。
 * 这种方法最合理的取值，红、绿、蓝的权重依次是 0.299 、0.587 、 0.114 。为了避免浮点运算，可以用移位替代。
 *
 * 注意：Qt 框架有一个 qGray() 函数，采取加权平均值法计算灰度。qGray()将浮点运算转为整型的乘法和除法，公式是(r * 11 + g * 16 + b * 5)/32，
 * 没有使用移位运算。
 */
static void _gray(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    qDebug() << "depth - " << image.depth();

    int width = image.width();
    int height = image.height();
    QRgb color;
    int gray;
    for(int i = 0; i < width; i++)
    {
        for(int j= 0; j < height; j++)
        {
            color = image.pixel(i, j);
            gray = qGray(color);
            image.setPixel(i, j, qRgba(gray, gray, gray, qAlpha(color)));
        }
    }

    image.save(destFile);
}
/* 黑白图片的处理算法比较简单：对一个像素的 R 、G 、B 求平均值，average = (R + G + B)/3 ，如果 average 大于等于选定的阈值则将该像素置为白色，
 * 小于阈值就把像素置为黑色。
 * 示例中我选择的阈值是 128 ，也可以是其它值，根据效果调整即可。比如你媳妇儿高圆圆嫌给她拍的照片黑白处理后黑多白少，那可以把阈值调低一些，取80，
 * 效果肯定就变了。
 */
static void _binarize(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    int width = image.width();
    int height = image.height();
    QRgb color;
    QRgb avg;
    QRgb black = qRgb(0, 0, 0);
    QRgb white = qRgb(255, 255, 255);
    for(int i = 0; i < width; i++)
    {
        for(int j= 0; j < height; j++)
        {
            color = image.pixel(i, j);
            avg = (qRed(color) + qGreen(color) + qBlue(color))/3;
            image.setPixel(i, j, avg >= 128 ? white : black);
        }
    }
    image.save(destFile);
}
/* 早些年的相机使用胶卷记录拍摄结果，洗照片比较麻烦，不过如果你拿到底片，逆光去看，效果就很特别。
 * 底片算法其实很简单，取 255 与像素的 R 、 G、 B 分量之差作为新的 R、 G、 B 值。
 */
static void _negative(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    int width = image.width();
    int height = image.height();
    QRgb color;
    QRgb negative;
    for(int i = 0; i < width; i++)
    {
        for(int j= 0; j < height; j++)
        {
            color = image.pixel(i, j);
            negative = qRgba(255 - qRed(color),
                             255 - qGreen(color),
                             255 - qBlue(color),
                             qAlpha(color));
            image.setPixel(i, j, negative);
        }
    }
    image.save(destFile);
}
/* "浮雕" 图象效果是指图像的前景前向凸出背景。
 * 浮雕的算法相对复杂一些，用当前点的 RGB 值减去相邻点的 RGB 值并加上 128 作为新的 RGB 值。由于图片中相邻点的颜色值是比较接近的，
 * 因此这样的算法处理之后，只有颜色的边沿区域，也就是相邻颜色差异较大的部分的结果才会比较明显，而其他平滑区域则值都接近128左右，也就是灰色，
 * 这样就具有了浮雕效果。
 */
static void _emboss(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    int width = image.width();
    int height = image.height();
    QRgb color;
    QRgb preColor = 0;
    QRgb newColor;
    int gray, r, g, b, a;
    for(int i = 0; i < width; i++)
    {
        for(int j= 0; j < height; j++)
        {
            color = image.pixel(i, j);
            r = qRed(color) - qRed(preColor) + 128;
            g = qGreen(color) - qGreen(preColor) + 128;
            b = qBlue(color) - qBlue(preColor) + 128;
            a = qAlpha(color);
            gray = qGray(r, g, b);
            newColor = qRgba(gray, gray, gray, a);
            image.setPixel(i, j, newColor);
            preColor = newColor;
        }
    }
    image.save(destFile);
}
/* 图像锐化的主要目的是增强图像边缘，使模糊的图像变得更加清晰，颜色变得鲜明突出，图像的质量有所改善，产生更适合人眼观察和识别的图像。
 * 常见的锐化算法有微分法和高通滤波法。微分法又以梯度锐化和拉普拉斯锐化较为常用。本示例采用微分法中的梯度锐化，
 * 用差分近似微分，则图像在点(i,j)处的梯度幅度计算公式如下：
 * G[f(i,j)] = abs(f(i,j) - f(i+1,j)) + abs(f(i,j) - f(i,j+1))
 * 为了更好的增强图像边缘，我们引入一个阈值，只有像素点的梯度值大于阈值时才对该像素点进行锐化，将像素点的 R 、 G、 B 值设置为对应的梯度值与一个常数
 * 之和。常数值的选取应当参考图像的具体特点。我们的示例为简单起见，将常数设定为 100 ，梯度阈值取 80 ，写死在算法函数中，更好的做法是通过参数传入，
 * 以便客户程序可以调整这些变量来观察效果。
 */
static void _sharpen(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    int width = image.width();
    int height = image.height();
    int threshold = 80;
    QImage sharpen(width, height, QImage::Format_ARGB32);
    int r, g, b, gradientR, gradientG, gradientB;
    QRgb rgb00, rgb01, rgb10;
    for(int i = 0; i < width; i++)
    {
        for(int j= 0; j < height; j++)
        {
            if(image.valid(i, j) &&
                    image.valid(i+1, j) &&
                    image.valid(i, j+1))
            {
                rgb00 = image.pixel(i, j);
                rgb01 = image.pixel(i, j+1);
                rgb10 = image.pixel(i+1, j);
                r = qRed(rgb00);
                g = qGreen(rgb00);
                b = qBlue(rgb00);
                gradientR = abs(r - qRed(rgb01)) + abs(r - qRed(rgb10));
                gradientG = abs(g - qGreen(rgb01)) + abs(g - qGreen(rgb10));
                gradientB = abs(b - qBlue(rgb01)) + abs(b - qBlue(rgb10));

                if(gradientR > threshold)
                {
                    r = qMin(gradientR + 100, 255);
                }

                if(gradientG > threshold)
                {
                    g = qMin( gradientG + 100, 255);
                }

                if(gradientB > threshold)
                {
                    b = qMin( gradientB + 100, 255);
                }

                sharpen.setPixel(i, j, qRgb(r, g, b));
            }
        }
    }

    sharpen.save(destFile);
}
/* 柔化又称模糊，图像模糊算法有很多种，我们最常见的就是均值模糊，即取一定半径内的像素值之平均值作为当前点的新的像素值。
 * 为了提高计算速度，我们取 3 为半径，就是针对每一个像素，将周围 8 个点加上自身的 RGB 值的平均值作为像素新的颜色值置。
 */
static void _soften(QString sourceFile, QString destFile)
{
    QImage image(sourceFile);
    if(image.isNull())
    {
        qDebug() << "load " << sourceFile << " failed! ";
        return;
    }
    int width = image.width();
    int height = image.height();
    int r, g, b;
    QRgb color;
    int xLimit = width - 1;
    int yLimit = height - 1;
    for(int i = 1; i < xLimit; i++)
    {
        for(int j = 1; j < yLimit; j++)
        {
            r = 0;
            g = 0;
            b = 0;
            for(int m = 0; m < 9; m++)
            {
                int s = 0;
                int p = 0;
                switch(m)
                {
                case 0:
                    s = i - 1;
                    p = j - 1;
                    break;
                case 1:
                    s = i;
                    p = j - 1;
                    break;
                case 2:
                    s = i + 1;
                    p = j - 1;
                    break;
                case 3:
                    s = i + 1;
                    p = j;
                    break;
                case 4:
                    s = i + 1;
                    p = j + 1;
                    break;
                case 5:
                    s = i;
                    p = j + 1;
                    break;
                case 6:
                    s = i - 1;
                    p = j + 1;
                    break;
                case 7:
                    s = i - 1;
                    p = j;
                    break;
                case 8:
                    s = i;
                    p = j;
                }
                color = image.pixel(s, p);
                r += qRed(color);
                g += qGreen(color);
                b += qBlue(color);
            }

            r = (int) (r / 9.0);
            g = (int) (g / 9.0);
            b = (int) (b / 9.0);

            r = qMin(255, qMax(0, r));
            g = qMin(255, qMax(0, g));
            b = qMin(255, qMax(0, b));

            image.setPixel(i, j, qRgb(r, g, b));
        }
    }

    image.save(destFile);
}


static AlgorithmFunction g_functions[ImageProcessor::AlgorithmCount] = {  //这个用法值得学习，保存函数指针的数组！
    _gray,
    _binarize,
    _negative,
    _emboss,
    _sharpen,
    _soften
};
//为了避免阻塞UI线程，图像处理模块放到线程池内完成，根据QThreadPool的要求，从QRunnable继承，实现下面的类
class AlgorithmRunnable : public QRunnable
{
public:
    AlgorithmRunnable(
            QString sourceFile,
            QString destFile,
            ImageProcessor::ImageAlgorithm algorithm,
            QObject * observer)
        : m_observer(observer)
        , m_sourceFilePath(sourceFile)
        , m_destFilePath(destFile)
        , m_algorithm(algorithm)
    {
    }
    ~AlgorithmRunnable(){}


    void run() //此函数执行完后发送自定义信号ExcutedEvent给ImageProcessor，而ImageProcessor就在处理事件时发出finished()信号
    {
        qDebug() << "algorithm running...";
        g_functions[m_algorithm](m_sourceFilePath, m_destFilePath);
        QCoreApplication::postEvent(m_observer, new ExcutedEvent(this));
    }

    QPointer<QObject> m_observer;
    QString m_sourceFilePath;
    QString m_destFilePath;
    ImageProcessor::ImageAlgorithm m_algorithm;
};

class ImageProcessorPrivate : public QObject
{
public:
    ImageProcessorPrivate(ImageProcessor *processor)
        : QObject(processor), m_processor(processor),
          m_tempPath(QDir::currentPath())
    {
        ExcutedEvent::evType();   //这句话不知道什么意思？！
    }
    ~ImageProcessorPrivate()
    {

    }

    bool event(QEvent * e)
    {
        if(e->type() == ExcutedEvent::evType())
        {
            ExcutedEvent *ee = (ExcutedEvent*)e;
            if(m_runnables.contains(ee->m_runnable))
            {
                m_notifiedAlgorithm = ee->m_runnable->m_algorithm;
                m_notifiedSourceFile = ee->m_runnable->m_sourceFilePath;
                emit m_processor->finished(ee->m_runnable->m_destFilePath);
                m_runnables.removeOne(ee->m_runnable);
            }
            delete ee->m_runnable;
            return true;
        }
        return QObject::event(e);
    }

    void process(QString sourceFile, ImageProcessor::ImageAlgorithm algorithm)
    {
        QFileInfo fi(sourceFile);
        QString destFile = QString("%1/%2_%3").arg(m_tempPath)
                .arg((int)algorithm).arg(fi.fileName());
        AlgorithmRunnable *r = new AlgorithmRunnable(sourceFile,
                                                     destFile,
                                                     algorithm,
                                                     this);
        m_runnables.append(r);
        r->setAutoDelete(false);
        QThreadPool::globalInstance()->start(r);
    }

    ImageProcessor * m_processor;
    QList<AlgorithmRunnable*> m_runnables;
    QString m_notifiedSourceFile;
    ImageProcessor::ImageAlgorithm m_notifiedAlgorithm;
    QString m_tempPath;
};

ImageProcessor::ImageProcessor(QObject *parent)
    : QObject(parent)
    , m_d(new ImageProcessorPrivate(this))
{}
ImageProcessor::~ImageProcessor()
{
    delete m_d;
}

QString ImageProcessor::sourceFile() const
{
    return m_d->m_notifiedSourceFile;
}

ImageProcessor::ImageAlgorithm ImageProcessor::algorithm() const
{
    return m_d->m_notifiedAlgorithm;
}

void ImageProcessor::setTempPath(QString tempPath)
{
    m_d->m_tempPath = tempPath;
}

void ImageProcessor::process(QString file, ImageAlgorithm algorithm)
{
    QUrl url(file);
    m_d->process(url.toLocalFile(), algorithm);
}

void ImageProcessor::abort(QString file, ImageAlgorithm algorithm)
{
    int size = m_d->m_runnables.size();
    AlgorithmRunnable *r;
    for(int i = 0; i < size; i++)
    {
        r = m_d->m_runnables.at(i);
        if(r->m_sourceFilePath == file && r->m_algorithm == algorithm)
        {
            m_d->m_runnables.removeAt(i);
            break;
        }
    }
}

void ImageProcessor::abortAll()
{
    m_d->m_runnables.clear();
}
