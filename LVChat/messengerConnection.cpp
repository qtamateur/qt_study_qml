#include "messengerConnection.h"
#include <QHostAddress>
#ifdef WIN32
#include <winsock2.h>
#else
#include <netinet/in.h>
#endif
#include <QTimerEvent>
#include "messengerManager.h"
#include <QFile>
#include <QDateTime>
#include <QDebug>
#include "protocol.h"
#include <QDir>

DiscoverConnection::DiscoverConnection(QObject *parent)
    : QTcpSocket(parent), m_nTimeout(0)
{
    connect(this, SIGNAL(connected()), this, SLOT(onConnected()));
    connect(this, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(this, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(deleteLater()));
}

DiscoverConnection::~DiscoverConnection()
{}

void DiscoverConnection::connectAp(quint32 addr, quint16 port)
{  //接收一个quint32类型的IPv4地址和一个quint16类型的端口号，然后连接对端，连接后在onReadyRead函数里面读取一行数据，判断是否
    //是discover报文，是的话就解析出昵称和头像索引，通过信号newAccessPoint()通知关心的那方
    QHostAddress address(addr);
    connectToHost(address, port);
    m_nTimeout = startTimer(500);
}

void DiscoverConnection::timerEvent(QTimerEvent *e)
{
    if(e->timerId() == m_nTimeout)
    {
        if(state() != QAbstractSocket::ConnectedState)
        {
            disconnect(this);
            abort();
            deleteLater();
        }
        killTimer(m_nTimeout);
        m_nTimeout = 0;
        return;
    }
    return QTcpSocket::timerEvent(e);
}

void DiscoverConnection::onConnected()
{
    killTimer(m_nTimeout);
    m_nTimeout = 0;
    write(DISCOVER_PACKET_FULL);
    flush();
    disconnect(this, SIGNAL(error(QAbstractSocket::SocketError)),
               this, SLOT(deleteLater()));
}

void DiscoverConnection::onReadyRead()
{
    m_data += readAll();
    int index = m_data.indexOf(PACKET_LINE_MARK);
    if(index != -1)
    {
        QString apInfo = QString::fromUtf8(m_data.left(index));
        QStringList infoList = apInfo.split(',');
        if(infoList.size() == 3 && infoList.at(0) == "discover")
        {
            AccessPoint *ap = new AccessPoint(infoList.at(1), infoList.at(2).toInt(), peerAddress());
            emit newAccessPoint(ap);
            qDebug() << "got an access point " << ap->m_address.toString() << " name " << ap->m_nickName << " portraitIndex " << ap->m_portraitIndex;
        }

        disconnect(this);
        close();
        deleteLater();
    }
}

TalkingConnection::TalkingConnection(QTcpSocket *sock, QObject *parent)
    : QObject(parent), m_socket(sock), m_bReady(false)
    , m_packetType(0), m_messageLength(0)
    , m_duration(0), m_peerAddress(0)
{
    if(sock)
    {
        QHostAddress host = sock->peerAddress();
        m_peerAddress = host.toIPv4Address();
        qDebug() << "accept a connection " << host.toString();
        setupSignalSlots();
    }
}

TalkingConnection::~TalkingConnection()
{
    if(m_socket)
    {
        m_socket->deleteLater();
        m_socket = 0;
    }
}

void TalkingConnection::accept()
{
    if(m_socket)
    {
        replyRequest(true);
        m_bReady = true;
        m_packetType = 0;
    }
}

void TalkingConnection::reject()
{
    if(m_socket)
    {
        if(m_socket->state() == QAbstractSocket::ConnectedState)
        {
            replyRequest(false);
        }
        closeConnection();
    }
    else
    {
        deleteLater();
    }
}

void TalkingConnection::talkTo(quint32 ip, quint16 port)
{ //分配一个QTcpSocket对象，连接指定地址，然后就是在onConnected槽中发送一个请求报文
    QHostAddress address(ip);
    m_socket = new QTcpSocket(this);
    setupSignalSlots();
    m_socket->connectToHost(address, port);
    m_nTimeout = startTimer(2000);
    m_peerAddress = ip;
}

void TalkingConnection::sendVoice(QByteArray &data, int duration, char *format)
{
    QString header = QString("message,%1,%2,%3,%4\r\n")
            .arg(PACKET_MESSAGE_VOICE)
            .arg(data.length())
            .arg(duration).arg(format);
    m_socket->write(header.toUtf8());
    m_socket->write(data);
    m_socket->flush();
    qDebug() << "sendVoice";
}

QString TalkingConnection::peerAddress()
{
    if(m_socket)
    {
        QHostAddress addr = m_socket->peerAddress();
        if(addr != QHostAddress::Null)
        {
            return addr.toString();
        }
    }
    return QString();
}

void TalkingConnection::onConnected()
{
    killTimer(m_nTimeout);
    m_nTimeout = 0;
    QString strReq = QString(TALK_REQ_PACKET_MARK)  //TALK_REQ_PACKET_MARK宏已经明确了报文格式,这里仅仅替换1%2%占位符
            .arg(MessengerManager::s_contact->m_nickName)
            .arg(MessengerManager::s_contact->m_portraitIndex);
    m_socket->write(strReq.toUtf8());   //构造完后write发送报文,然后转入onReadyRead和processPacket函数了！
    m_socket->flush();
}

void TalkingConnection::onReadyRead()
{
    m_data += m_socket->readAll();
    processPacket();
}

void TalkingConnection::onError(QAbstractSocket::SocketError code)
{
    m_socket->deleteLater();
    m_socket = 0;
    emit peerGone(m_peerAddress);
    deleteLater();
}

void TalkingConnection::timerEvent(QTimerEvent *e)
{
    if(e->timerId() == m_nTimeout)
    {
        if(m_socket->state() != QAbstractSocket::ConnectedState)
        {
            m_socket->disconnect(this);
            m_socket->abort();
            m_socket->deleteLater();
            m_socket = 0;
            deleteLater();
        }
        killTimer(m_nTimeout);
        m_nTimeout = 0;
        return;
    }
    return QObject::timerEvent(e);
}

void TalkingConnection::processPacket()
{
    switch(m_packetType)
    { //因为是TCP通信，可能存在粘包或碎包问题，比如语音消息使用\r\n分割了消息体和消息头，一次读取的数据可能跨越这个边界却没有抵达
    //消息结束那个点。所以判断如果为PACKET_MESSAGE就调用processMessage函数专门处理！成功则把m_packetType置为0同时返回1
    case PACKET_MESSAGE:
        if( processMessage() && m_data.length() ) processPacket(); //processMessage成功则继续向前处理报文,否则返回
        return;
    case 0:
        break;
    default:
        return;
    }
//下面的报文类型比较简单,比如发现、聊天请求等,收到报文边界(\r\n)时消息也就结束了
    int index = m_data.indexOf(PACKET_LINE_MARK);
    if(index == -1) return;
//上面两行收到报文边界，下面才判断类型
    if(m_data.startsWith(DISCOVER_PACKET))
    {
        m_packetType = PACKET_DISCOVER;
        discoverReply();
    }
    else if(m_data.startsWith(TALK_REQ_TOKEN))
    {
        m_packetType = PACKET_TALK_REQ;
        int start = m_data.indexOf(',');
        start++;
        QString peerInfo = QString::fromUtf8(m_data.mid(start, index - start));
        QStringList infoList = peerInfo.split(',');
        if(infoList.size() == 2)
        {
            Peer *peer = new Peer(infoList.at(0), infoList.at(1).toInt(), this);
            emit incomingMessenger(peer);
        }
        m_data = m_data.mid(index + 2);
    }
    else if(m_data.startsWith(TALK_ACCEPT_PACKET))
    {
        emit talkingAccepted();
        m_data = m_data.mid(index + 2);
        if(m_data.length()) processPacket();
    }
    else if(m_data.startsWith(TALK_REJECT_PACKET))
    {
        m_packetType = PACKET_TALK_REJECT;
        closeConnection();
        emit talkingRejected();
    }
    else if(m_data.startsWith(MESSAGE_PACKET_MARK))
    {
        QByteArray header = m_data.left(index);
        m_data = m_data.mid(index+2);
        QList<QByteArray> headers = header.split(',');
        if(headers.size() != 5)
        {
            closeConnection();
            return;
        }
        bool ok = false;
        m_messageType = headers.at(1).toUInt(&ok);
        if(!ok || m_messageType != PACKET_MESSAGE_VOICE)
        {
            closeConnection();
            return;
        }
        m_messageLength = headers.at(2).toUInt(&ok);
        if(!ok)
        {
            closeConnection();
            return;
        }
        m_duration = headers.at(3).toInt(&ok);
        m_format = headers.at(4);
        m_packetType = PACKET_MESSAGE;
        if( processMessage() && m_data.length() ) processPacket();
    }
}


void TalkingConnection::replyRequest(bool agree)
{
    const char *packet = agree ? TALK_ACCEPT_PACKET_FULL : TALK_REJECT_PACKET_FULL;
    m_socket->write(packet);
    m_socket->flush();
}

void TalkingConnection::discoverReply()
{
    QString strReply = QString(DISCOVER_REPLY_MARK)
            .arg(MessengerManager::s_contact->m_nickName)
            .arg(MessengerManager::s_contact->m_portraitIndex);
    m_socket->write(strReply.toUtf8());
    //qDebug() << "after write name to client";
    m_socket->flush();
    closeConnection();
    //qDebug() << "TalkingConnection, discoverReply";
}

void TalkingConnection::closeConnection()
{
    m_socket->disconnect(this);
    m_socket->close();
    m_socket->deleteLater();
    m_socket = 0;
    deleteLater();
}

void TalkingConnection::setupSignalSlots()
{
    connect(m_socket, SIGNAL(connected()),this, SLOT(onConnected()));
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(m_socket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(onError(QAbstractSocket::SocketError)));
}

int TalkingConnection::processMessage()
{ //如果接收的数据长度小于预期消息体长度，就返回0
    if(m_data.length() < m_messageLength) return 0;
//如果接收了完整的语音消息,就保存到以日期命名的本地文件中,成功则发送incomingVoice信号,然后擦除已处理数据,重置m_packetType等状态变量
    QString fileName = QString("%1/%2.%3")
            .arg(QDir::currentPath())
            .arg(QDateTime::currentDateTime().toString("yyyy-MM-dd_hh-mm-ss"))
            .arg(m_format.data());
    QFile file(fileName);
    if(file.open(QFile::WriteOnly))
    {
        file.write(m_data.data(), m_messageLength);
        file.close();
        emit incomingVoice(fileName, m_duration);
    }

    if(m_data.length() > m_messageLength)
    {
        m_data = m_data.mid(m_messageLength);
    }
    else
    {
        m_data.clear();
    }
    m_packetType = 0;
    m_messageLength = 0;
    m_duration = 0;
    m_format.clear();
    return 1;
}
