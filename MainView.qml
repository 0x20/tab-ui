import QtQuick 2.4
import QtQuick.Layouts 1.3
import "controls"

Rectangle {

    signal switchToTransfer()
    signal switchToDeposit()
    signal switchToStats()

    signal depositCommand(string member, int amount)
    signal purchaseCommand(string member, var bill)

    id: mainView

    property bool depositMode: false

    color: "black"
    Rectangle {
        // This is a cheat to use anchor-based layout with fixed object sizes
        id: centerBlip

        x:  parent.width - (application.buttonWidth + 10) * 3 - 10
        y: 319
        width: 0
        height: 10
        color: "#004000"
        anchors.margins: 10
    }

    LogView {
        id: logView

        anchors {
            left: parent.left
            right: centerBlip.left
            top: parent.top
            bottom: utils.top
            bottomMargin: 0
        }

    }

    TallyView {
        id: tally

        anchors {
            left: centerBlip.right
            right: parent.right
            top: parent.top
            bottom: centerBlip.top
        }
    }

    UtilView {
        id: utils
        anchors {
            left: parent.left
            bottom: centerBlip.top
            right: centerBlip.left
        }

        onSwitchToDeposit: {
            depositMode = !depositMode
        }

        onSwitchToStats: parent.switchToStats()
        onSwitchToTransfer: parent.switchToTransfer()
    }

    StackLayout {
        anchors {
            left: parent.left
            right: centerBlip.left
            top: centerBlip.bottom
            bottom: parent.bottom
        }

        currentIndex: depositMode ? 1 : 0

        ProductList {
            id: productList
            onSelected: {
                var product = productModel.get(index)
                tallyModel.addItem(product.internal_name, product.name, product.cost, 1)
            }
        }


        Item {
            NumberEntry {
                id: depositEntry
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10

                hasNegate: true
            }
        }

    }

    MemberList {
        id: memberList
        anchors {
            left: centerBlip.right
            right: parent.right
            top: centerBlip.bottom
            bottom: parent.bottom
        }

        onSelected: {
            if (depositMode && depositEntry.value > 0) {
                depositCommand(name, depositEntry.value)
                depositMode = false
                depositEntry.reset()
            } else if (!depositMode && tallyModel.count > 0) {
                var bill = []
                for (var i = 0; i < tallyModel.count; i++) {
                    var item = tallyModel.get(i)
                    bill.push(item)
                }
                purchaseCommand(name, bill)
                tallyModel.clear()
            } else {
                var pos = members.memberPosition(name)
                var member = members.get(pos)

                logModel.log(member["name"] + " has a balance of " + formatCurrency(member["balance"])).confirm();
            }
        }
    }
}
