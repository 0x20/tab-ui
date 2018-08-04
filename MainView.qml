import QtQuick 2.4

Item {
    Rectangle {
        // This is a cheat to use anchor-based layout with fixed object sizes
        id: centerBlip

        x:  parent.width - 140 * 3 - 12
        y: 240
        width: 2
        height: 2
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
            bottomMargin: 2
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
