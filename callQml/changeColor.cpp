#include "changeColor.h"
#include <QDateTime>
#include <QColor>
#include <QVariant>

ChangeQmlColor::ChangeQmlColor(QObject *target, QObject *parent)
    : QObject(parent)
    , m_timer(this)
    , m_target(target)
{
    qsrand(QDateTime::currentDateTime().toTime_t());
    connect(&m_timer, SIGNAL(timeout()), this, SLOT(onTimeout()));
    m_timer.start(1000);
}

ChangeQmlColor::~ChangeQmlColor()
{}

void ChangeQmlColor::onTimeout()
{
    QColor color = QColor::fromRgb(qrand()%256, qrand()%256, qrand()%256);
    m_target->setProperty("color", color);  //Sets the value of the object's name property to value.
                                            //厉害，qml里面属性的值也能改变！！
}
