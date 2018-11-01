#ifndef TQMEMBERMODEL_H
#define TQMEMBERMODEL_H

#include <QAbstractListModel>

struct BarMember {
    QString name;
    QString internal_name;
    int balance;
    int items;
};

enum MemberModelRoles {
    MEMBER_ROLE_NAME = Qt::UserRole + 1,
    MEMBER_ROLE_INTERNAL_NAME,
    MEMBER_ROLE_BALANCE,
    MEMBER_ROLE_ITEMS,
};

class TqMemberModel : public QAbstractListModel
{
    Q_OBJECT

    QVector<BarMember> m_members;
    QMap<QString, int> m_memberPositions;

public:
    explicit TqMemberModel(QObject *parent = nullptr);

    // Loading
    Q_INVOKABLE bool loadFromJson(QMap<QString, QVariant> data);
    Q_INVOKABLE int memberPosition(QString &internal_name) const;
    Q_INVOKABLE void applyDelta(QString &internal_name, int dBalance, int dItems);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    // Role names
    QHash<int, QByteArray> roleNames() const override;

private:
};

#endif // TQMEMBERMODEL_H
