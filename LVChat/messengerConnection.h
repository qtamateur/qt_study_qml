#ifndef ServerConnection_H
#define ServerConnection_H
#include <QObject>
#include <QTcpSocket>
#include "protocol.h"
#include <QByteArray>
#include <QHostAddress>
#include <QPointer>

class Contact;
class Peer;
class AccessPoint;
//负责连接一个地址的类
class DiscoverConnection : public QTcpSocket
{
    Q_OBJECT
public:
    DiscoverConnection(QObject *parent = 0);
    ~DiscoverConnection();

    void connectAp(quint32 addr, quint16 port);

signals:
    void newAccessPoint(AccessPoint *ap);

protected:
    void timerEvent(QTimerEvent *e);

protected slots:
    void onConnected();
    void onReadyRead();

private:
    int m_nTimeout;
    QByteArray m_data;
};
//处理发现、请求、应答、消息等报文，既实现了客户端的功能，又实现了服务器的功能
class TalkingConnection : public QObject
{
    Q_OBJECT
public:
    TalkingConnection(QTcpSocket *sock = 0, QObject *parent = 0);
    ~TalkingConnection();

    void accept();    //接受对方的聊天请求
    void reject();    //拒绝对方的聊天请求
    void talkTo(quint32 ip, quint16 port);    //发起聊天请求
    void sendVoice(QByteArray &data, int duration, char *format);  //向对方发送一条语音消息
    QString peerAddress();

signals:
    void talkingAccepted();    //从对方来的接受
    void talkingRejected();    //从对方来的拒绝
    void incomingMessenger(Peer *peer);    //从对方来的请求聊天
    void incomingVoice(QString fileName, int duration);    //语音消息
    void peerGone(quint32 peerAddr); //错误或者从对方来的粗暴退出
    //上面这些信号经过MessengerManager的转发，最终提供给QML环境访问
protected slots:
    void onConnected();
    void onReadyRead();
    void onError(QAbstractSocket::SocketError code);

protected:
    void timerEvent(QTimerEvent *e);

private:
    void processPacket();  //接受对方消息最关键的函数
    void replyRequest(bool agree);
    void discoverReply();
    int processMessage();
    void closeConnection();
    void setupSignalSlots();

private:
    QTcpSocket *m_socket;
    bool m_bReady;
    int m_nTimeout;
    int m_packetType;   //保存当前正在处理的报文类型
    quint32 m_messageType;
    quint32 m_messageLength;
    QByteArray m_data;
    qint32 m_duration;
    QByteArray m_format;
    quint32 m_peerAddress;
};

class Contact
{
public:
    Contact(): m_portraitIndex(0)
    {
    }
    Contact(const QString &nickName, int portraitIndex)
        : m_nickName(nickName), m_portraitIndex(portraitIndex)
    {}

    virtual ~Contact(){}

    QString m_nickName;
    int m_portraitIndex;
};

class AccessPoint : public Contact
{
public:
    AccessPoint(const QString &nickName, int portraitIndex, const QHostAddress &addr)
        : Contact(nickName, portraitIndex)
        ,m_address(addr)
    {
    }
    ~AccessPoint()
    {
    }

    QHostAddress m_address;
};

class Peer : public Contact
{
public:
    Peer(const QString &nickName, int portraitIndex, TalkingConnection *conn)
        : Contact(nickName, portraitIndex)
        ,m_connection(conn)
    {

    }
    ~Peer()
    {
        if(m_connection)m_connection->reject();
    }

    QPointer<TalkingConnection> m_connection;
};

#endif // ServerConnection_H
