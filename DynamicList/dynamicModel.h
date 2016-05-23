/* DynamicListModel仅仅是演示用法，使用m_start、m_end、m_total、m_pageSize四个整型变量来模拟实际的数据。而data()方法，
 * 将ListView内的行序号加上m_start转换为字符串返回，就是我们在ListView界面上看到了文字了。
 * loadMore()函数，区分向前还是向后加载数据，它调用DynamicListModel的pageDown()、pageUp()来更新内部的数据状态。
 * 在loadMore()一开始，调用beginResetModel()，通知关联到DynamicListModel上的view们刷新自己，当内部数据状态更新结束后，
 * 调用endResetModel()来通知view们，这样view们就会刷新，最终在实例化item delegate时调用data()方法来准备数据，此时m_start已变化，
 * 所以界面上看到的数字也跟着变了。
 */
#ifndef DYNAMICMODEL_H
#define DYNAMICMODEL_H
#include <QAbstractListModel>

class DynamicListModelPrivate;
class DynamicListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int pageSize READ pageSize WRITE setPageSize NOTIFY pageSizeChanged)
    Q_PROPERTY(int total READ total WRITE setTotal NOTIFY totalChanged)
public:
    DynamicListModel(QObject *parent = 0);
    ~DynamicListModel();

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void loadMore(bool forward);

    int pageSize();
    void setPageSize(int size);
    int total();
    void setTotal(int total);

signals:
    void pageSizeChanged(int size);
    void totalChanged(int total);

private:
    DynamicListModelPrivate *m_dptr;
};

#endif // DYNAMICMODEL_H
