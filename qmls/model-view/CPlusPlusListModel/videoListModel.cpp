#include "videoListModel.h"
#include <QXmlStreamReader>
#include <QVector>
#include <QFile>
#include <QDebug>

typedef QVector<QString> VideoData;  //一条视频记录13个role的数据，我们使用QVector<QString>保存这13个role
class VideoListModelPrivate
{
public:
    VideoListModelPrivate()
        : m_bError(false)
    {
        int role = Qt::UserRole;
        m_roleNames.insert(role++, "name");
        m_roleNames.insert(role++, "date");
        m_roleNames.insert(role++, "director_tag");
        m_roleNames.insert(role++, "director");
        m_roleNames.insert(role++, "actor_tag");
        m_roleNames.insert(role++, "actor");
        m_roleNames.insert(role++, "rating_tag");
        m_roleNames.insert(role++, "rating");
        m_roleNames.insert(role++, "desc_tag");
        m_roleNames.insert(role++, "desc");
        m_roleNames.insert(role++, "img");
        m_roleNames.insert(role++, "playpage");
        m_roleNames.insert(role++, "playtimes");
    }

    ~VideoListModelPrivate()
    {
        clear();
    }

    void load()    //load方法使用QXmlStreamReader解析xml文档
    {
        QXmlStreamReader reader;
        QFile file(m_strXmlFile);
        if(!file.exists())
        {
            m_bError = true;
            m_strError = "File Not Found!";
            return;
        }
        if(!file.open(QFile::ReadOnly))
        {
            m_bError = true;
            m_strError = file.errorString();
            return;
        }
        reader.setDevice(&file);
        QStringRef elementName;
        VideoData * video;
        while(!reader.atEnd())
        {
            reader.readNext();
            if(reader.isStartElement())
            {
                elementName = reader.name();
                if( elementName == "video")
                {
                    video = new VideoData();
                    QXmlStreamAttributes attrs = reader.attributes();
                    video->append(attrs.value("name").toString());
                    video->append(attrs.value("date").toString());
                }
                else if( elementName == "attr")
                {
                    video->append(reader.attributes().value("tag").toString());
                    video->append(reader.readElementText());
                }
                else if( elementName == "poster")
                {
                    video->append(reader.attributes().value("img").toString());
                }
                else if( elementName == "page" )
                {
                    video->append(reader.attributes().value("link").toString());
                }
                else if( elementName == "playtimes" )
                {
                    video->append(reader.readElementText());
                }
            }
            else if(reader.isEndElement())
            {
                elementName = reader.name();
                if( elementName == "video")
                {
                    m_videos.append(video);
                    video = 0;
                }
            }
        }
        file.close();
        if(reader.hasError())
        {
            m_bError = true;
            m_strError = reader.errorString();
        }
    }

    void reset()
    {
        m_bError = false;
        m_strError.clear();
        clear();
    }

    void clear()
    {
        int count = m_videos.size();
        if(count > 0)
        {
            for(int i = 0; i < count; i++)
            {
                delete m_videos.at(i);
            }
            m_videos.clear();
        }
    }

    QString m_strXmlFile;   //存储读取xml文件的路径
    QString m_strError;
    bool m_bError;
    QHash<int, QByteArray> m_roleNames;   //保存了roleNames()方法需要的哈希表，在构造函数中根据videos.xml文件初始化这个哈希表
    QVector<VideoData*> m_videos;  //其内部的每个元素代表了Model内的一条数据，也是ListView要展示的一个条目
};

VideoListModel::VideoListModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_dptr(new VideoListModelPrivate)
{
}

VideoListModel::~VideoListModel()
{
    delete m_dptr;
}

int VideoListModel::rowCount(const QModelIndex &parent) const
{
    return m_dptr->m_videos.size();
}

QVariant VideoListModel::data(const QModelIndex &index, int role) const
{
    VideoData *d = m_dptr->m_videos[index.row()];  //使用row()方法找到行索引，据此从m_videos定位到VideoData
    return d->at(role - Qt::UserRole);   //然后传入的role减去作为基准的UserRole来定位role对应的数据
}

QHash<int, QByteArray> VideoListModel::roleNames() const
{
    return m_dptr->m_roleNames;
}

QString VideoListModel::source() const
{
    return m_dptr->m_strXmlFile;
}

void VideoListModel::setSource(const QString& filePath)
{
    m_dptr->m_strXmlFile = filePath;
    reload();
    if(m_dptr->m_bError)
    {
        qDebug() << "VideoListModel,error - " << m_dptr->m_strError;
    }
}

QString VideoListModel::errorString() const
{
    return m_dptr->m_strError;
}

bool VideoListModel::hasError() const
{
    return m_dptr->m_bError;
}
/* reload()实现比较典型，是我们自己实现Model时的常见做法，先调用基类的beginResetModel()，然后重置Model内部状态，最后调用基类的endResetModel()
 * 基类的beginResetModel()和endResetModel()两个方法会发射正确的信号来通知关联到Model上的view刷新界面！！
 */
void VideoListModel::reload()
{
    beginResetModel();

    m_dptr->reset();
    m_dptr->load();

    endResetModel();
}
/* 当你允许从qml中修改C++实现的Model时，比如删除，就需要做这么几件事情：
 * 1.调用beginRemoveRows()
 * 2.针对要删除的数据进行特定处理，比如是否内存
 * 3.调用endRemoveRows()
 * 注意，基类的beginRemoveRows()和endRemoveRows()两个方法会发射正确的信号来通知关联到Model上的view正确处理界面上的事情！！
 */
void VideoListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    delete m_dptr->m_videos.takeAt(index);
    endRemoveRows();
}
/* 向Model中添加数据的做法类似，需要调用beginInsertRows()和endInsertRows(),具体要看QAbstractItemModel的API文档！！
 */
