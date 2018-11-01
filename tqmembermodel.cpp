#include <math.h>
#include <algorithm>
#include "tqmembermodel.h"

TqMemberModel::TqMemberModel(QObject *parent)
    : QAbstractListModel(parent),
      m_members(),
      m_memberPositions()
{
}

QVariant TqMemberModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    (void)section;
    (void)orientation;

    switch (role) {
    case MEMBER_ROLE_NAME:
        return QVariant("Name");
    case MEMBER_ROLE_INTERNAL_NAME:
        return QVariant("Internal name");
    case MEMBER_ROLE_BALANCE:
        return QVariant("Balance");
    case MEMBER_ROLE_ITEMS:
        return QVariant("Items bought");
    default:
        return QVariant();
    }
}

bool TqMemberModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    (void)section;
    (void)orientation;
    (void)value;
    (void)role;

    return false;
}

QHash<int, QByteArray> TqMemberModel::roleNames() const
{
    return QHash<int, QByteArray>({
                                      {MEMBER_ROLE_NAME, "name"},
                                      {MEMBER_ROLE_INTERNAL_NAME, "internal_name"},
                                      {MEMBER_ROLE_BALANCE, "balance"},
                                      {MEMBER_ROLE_ITEMS, "items_bought"},
                                  });
}

int TqMemberModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_members.length();
}

QVariant TqMemberModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() >= m_members.length()) {
        return QVariant();
    }

    const BarMember* member = &m_members[index.row()];

    switch (role) {
    case MEMBER_ROLE_NAME:
        return QVariant(member->name);
    case MEMBER_ROLE_INTERNAL_NAME:
        return QVariant(member->internal_name);
    case MEMBER_ROLE_BALANCE:
        return QVariant(member->balance);
    case MEMBER_ROLE_ITEMS:
        return QVariant(member->items);
    default:
        return QVariant();
    }
}

bool TqMemberModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool success;
    if (data(index, role) != value) {
        // We know that the index is valid
        BarMember *member = &m_members[index.row()];
        int newValue;
        switch (role) {
        case MEMBER_ROLE_BALANCE:
            newValue = value.toInt(&success);
            if (!success) {
                return false;
            }
            member->balance = newValue;
            break;
        case MEMBER_ROLE_ITEMS:
            newValue= value.toInt(&success);
            if (!success) {
                return false;
            }
            member->items = newValue;
            break;
        default:
            return false;
        }
        // FIXME: Implement me!
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags TqMemberModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable; // FIXME: Implement me!
}

// Loading

bool TqMemberModel::loadFromJson(QMap<QString, QVariant> data) {
    QVector<BarMember> newMembers = QVector<BarMember>();
    QMap<QString, int> memberPos = QMap<QString, int>();

    for (auto it = data.cbegin(); it != data.cend(); it++) {
        if (it.value().type() != QVariant::Map) {
            return false;
        }

        const QVariantMap jsonMember = it.value().toMap();
        if (!jsonMember.contains("display_name")) return false;
        if (!jsonMember.contains("balance")) return false;

        int balance = lrintf(jsonMember.value("balance").toFloat() * 100.f);

        const BarMember newMember = {
            .name = jsonMember.value("display_name").toString(),
            .internal_name = it.key(),
            .balance = balance,
            .items = jsonMember.value("items").toInt(),
        };

        newMembers.push_back(newMember);
    }

    qSort(newMembers.begin(), newMembers.end(), [](BarMember &a, BarMember &b) {
        // Cash should be sorted first
        if (a.internal_name == "--cash--") {
            return true;
        } else if (b.internal_name == "--cash--") {
            return false;
        }

        if (a.items > b.items) {
            return true;
        } else if (a.items < b.items) {
            return false;
        }
        return a.name < b.name;
    });

    for (int i = 0; i < newMembers.length(); i++) {
        memberPos[newMembers[i].internal_name] = i;
    }

    int oldLength = m_members.length(),
            newLength = newMembers.length();
    if (oldLength > newLength) {
        beginRemoveRows(QModelIndex(), newLength, oldLength - 1);
        m_members = newMembers;
        m_memberPositions = memberPos;
        endRemoveRows();
    } else if (newLength > oldLength) {
        beginInsertRows(QModelIndex(), oldLength, newLength - 1);
        m_members = newMembers;
        m_memberPositions = memberPos;
        endInsertRows();
    } else {
        m_members = newMembers;
        m_memberPositions = memberPos;
    }
    dataChanged(createIndex(0, 0), createIndex(qMin(oldLength, newLength) - 1, 0));
    return true;
}

int TqMemberModel::memberPosition(QString internal_name) const {
    return m_memberPositions.value(internal_name, -1);
}

void TqMemberModel::applyDelta(QString internal_name, int dBalance, int dItems) {
    int starting_pos = m_memberPositions.value(internal_name, -1);
    if (starting_pos < 0) {
        return;
    }
    m_members[starting_pos].balance = dBalance;
    m_members[starting_pos].items = dItems;
    int newItemCount = m_members[starting_pos].items;

    // sort if necessary
    int target_pos = starting_pos;
    while (target_pos > 0 && newItemCount > m_members[target_pos-1].items) {
        target_pos--;
    }
    while (target_pos < m_members.length() - 1 && newItemCount < m_members[target_pos+1].items) {
        target_pos++;
    }

    if (target_pos < starting_pos) {
        BarMember temp = m_members[starting_pos];
        std::copy_backward(
                    m_members.begin() + target_pos,
                    m_members.begin() + starting_pos - 1,
                    m_members.begin() + target_pos + 1);
        m_members[target_pos] = temp;
        for (int i = target_pos; i <= starting_pos; i++) {
            m_memberPositions[m_members[i].internal_name] = i;
        }
    } else if (target_pos > starting_pos) {
        BarMember temp = m_members[starting_pos];
        std::copy(
                    m_members.begin() + starting_pos + 1,
                    m_members.begin() + target_pos - 1,
                    m_members.begin() + starting_pos);
        m_members[target_pos] = temp;
        for (int i = starting_pos; i <= target_pos; i++) {
            m_memberPositions[m_members[i].internal_name] = i;
        }
    }
    dataChanged(createIndex(qMin(starting_pos, target_pos), 0),
                createIndex(qMax(starting_pos, target_pos), 0));
}

QVariant TqMemberModel::get(QVariant id) {
	int memberId = -1;
	if (id.type() == QVariant::String) {
		memberId = m_memberPositions.value(id.toString(), -1);
	}
	if (memberId == -1) {
		bool success = true;
		memberId = id.toInt(&success);
		if (!success) {
			return QVariant();
		}
	}

	if (memberId < 0 || memberId >= m_members.length()) {
		return QVariant();
	}

	// We have a valid member ID; construct the result hash
	BarMember *member = &m_members[memberId];

	QVariantMap result = QVariantMap();
	result["name"] = member->name;
	result["internal_name"] = member->internal_name;
	result["balance"] = member->balance;
	result["item_count"] = member->items;
	return result;
}
