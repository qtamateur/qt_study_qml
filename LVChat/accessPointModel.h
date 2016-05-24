#ifndef AccessPointModel_H
#define AccessPointModel_H
#include <QAbstractListModel>

class AccessPoint;
class AccessPointModelPrivate;
//供QML使用的model类
class AccessPointModel : public QAbstractListModel
{ //下面两个供QML访问的属性主要是方便QML的多个界面之间传递要聊天的那个朋友的信息
    Q_OBJECT
    Q_PROPERTY(QString currentNick READ currentNick)
    Q_PROPERTY(int currentPortraitIndex READ currentPortraitIndex)
public:
    AccessPointModel(QObject *parent = 0);
    ~AccessPointModel();

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE void scan();  //确认按钮单机是调用此函数，搜索按钮时也会调用，内部的m_dptr负责扫描联系人的工作
    Q_INVOKABLE void talkTo(int index); //当用户点击“聊”按钮时，会调用此方法！
    QString currentNick();
    int currentPortraitIndex();

signals:
    void scanFinished();

private slots:
    void onNewAccessPoint(AccessPoint *ap);  //发现新联系人时调用次slot

private:
    AccessPointModelPrivate *m_dptr;
};

#endif // AccessPointModel_H
