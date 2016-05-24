#ifndef MESSENGER_MANAGER_H
#define MESSENGER_MANAGER_H
#include <QTcpServer>
#include "messengerConnection.h"

//服务器的实现非常简单，只是接受连接，然后创建一个TalkingConnection对象让它来处理与客户端的交互
class MessengerManager : public QTcpServer
{
    Q_OBJECT
    MessengerManager(QObject *parent = 0);
public:
    ~MessengerManager();

    Q_INVOKABLE void acceptNewMessenger();
    Q_INVOKABLE void rejectNewMessenger();
    Q_INVOKABLE void closeCurrentSession();  //关闭和m_currentPeer相关的会话

    static Contact * s_contact;
    //start函数保存昵称和头像的索引，然后调用listen()监听到预定义端口上
    Q_INVOKABLE void start(QString nickName, int portraitIndex);

    void talkTo(AccessPoint *ap);

    static MessengerManager *instance();
    Q_INVOKABLE void sendVoiceMessage(QString fileName, qint64 duration);

signals:
    void newMessenger(QString name, int portraitIndex, QString address);
    void chatAccepted();
    void chatRejected();
    void voiceMessageArrived(QString fileName, int duration);
    void peerGone();

protected slots:
    void onNewConnection();  //里面取出所有挂起的已接受连接，交给TalkingConnection类来处理
    void onIncomingMessenger(Peer *peer);

private:
    void setupSignalSlots(TalkingConnection *conn);

private:
    Peer * m_currentPeer;  //保存正在聊天的那个朋友
    Peer * m_pendingPeer;  //保存排队等号的那个朋友
};

#endif // MessengerManager_H
