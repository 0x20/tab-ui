import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "controls"
import "http.js" as Http
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
            text: "Deposit"
            onClicked: switchToDeposit()
        }

        TqButton {
            text: "Transfer"
            onClicked: switchToTransfer()
        }

        TqButton {
            text: "Sync"
            onClicked: {
                Http.get(application.backend_url + "/api/v1/admin/update", function() {
                    application.loadAllData()
                })

            }
        }

        TqButton {
            text: "Stats"
            onClicked: switchToStats()
        }
    }
}
