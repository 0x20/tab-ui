import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "controls"

Rectangle {
    signal switchToTransfer()
    signal switchToDeposit()
    signal switchToStats()
    signal foo()

    color: application.layoutColor("#004040")
    height: application.buttonHeight + 20
    RowLayout {
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: 10
        TqButton {
            text: depositMode ? "Buy" : "Deposit"
            onClicked: switchToDeposit()
        }

        TqButton {
            text: "Transfer"
            onClicked: switchToTransfer()
        }

        TqButton {
            text: "Sync"
            onClicked: {
                application.loadAllData(true)
            }
        }

        TqButton {
            text: "Stats"
            onClicked: switchToStats()
        }
    }
}
