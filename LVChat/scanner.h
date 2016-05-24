#ifndef SCANNER_H
#define SCANNER_H
#include <QObject>
#include <QTcpSocket>
#include <QList>

/* 发现潜在聊天对象类，采用最原始方式：TCP端口扫描。
 * 代码中根据终端的IP地址，计算它所在网络内有多少个地址，然后一一去连接这些地址的指定端口，如果这个地址回应了预定的报文，就认为对应的主机
 * 上运行了这个程序！
 */
class AccessPoint;
class AccessPointScanner : public QObject
{
    Q_OBJECT
public:
    AccessPointScanner(QObject *parent = 0);
    ~AccessPointScanner();

    void startScan();  //调用这个函数开始扫描

signals:
    void newAccessPoint(AccessPoint *ap);
    void scanFinished();

protected slots:
    void onDiscoverSocketDestroyed();

private:
    void scanAps();
    void initializeScanList();
    int ipCount(int prefixLength);
    bool compareAccessPoints();
    void scanOneAp();

private:
    QList<quint32> m_scanList;  //存放扫描的IPv4地址
    int m_index;
    int m_finished;
};

#endif // SCANNER_H
