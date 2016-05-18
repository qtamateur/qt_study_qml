#ifndef VIDEOLISTMODEL_H
#define VIDEOLISTMODEL_H
#include <QAbstractListModel>

/* XmlListMOdel就是C++实现QQuickXmlListModel然后导出到QML环境中的，可以从QAbstractItemModel或QAbstractListModel继承来实现自己的Model
 * 类，后者相对简单，下面实现一个VideoListModel来解析videos.xml文件
 */

class VideoListModelPrivate;
class VideoListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)   //导出一个source属性，在qml中指定要解析的xml文件

public:
    VideoListModel(QObject *parent = 0);
    ~VideoListModel();
    //下面三个函数需要重写，是必要的！
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    QString source() const;
    void setSource(const QString& filePath);
    //下面是用于检查错误的函数
    Q_INVOKABLE QString errorString() const;
    Q_INVOKABLE bool hasError() const;

    Q_INVOKABLE void reload();   //从新加载Model数据
    Q_INVOKABLE void remove(int index);   //允许删除指定位置的数据

private:
    VideoListModelPrivate *m_dptr;   //数据成员隔离在VideoListModelPrivate类中实现
};

#endif // VIDEOLISTMODEL_H
