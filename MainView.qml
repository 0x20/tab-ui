import QtQuick 2.4

Rectangle {

    signal switchToTransfer()
    signal switchToDeposit()
    signal switchToStats()

    id: mainView

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

        onSwitchToDeposit: parent.switchToDeposit()
        onSwitchToStats: parent.switchToStats()
        onSwitchToTransfer: parent.switchToTransfer()
    }

    ProductList {
        id: productList

        anchors {
            left: parent.left
            right: centerBlip.left
            top: centerBlip.bottom
            bottom: parent.bottom
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
            var bill = []
            for (var i = 0; i < tallyModel.count; i++) {
                var item = tallyModel.get(i)
                bill.push(item)
            }

            application.handlePurchase(name, bill)
        }
    }
}
