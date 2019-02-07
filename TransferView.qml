import QtQuick 2.0
import QtQuick.Layouts 1.3
import "Colors.js" as Colors
import "controls"

Rectangle {
    color: "black"

    id: view

    signal accepted(string from, string to, int amount)
    signal canceled

    function reset() {
        fromSelector.selectedIndex = -1
        toSelector.selectedIndex = -1
        amount.reset()
    }

    MemberList {
        id: fromSelector
        anchors.right: parent.right
        anchors.top: parent.top
//        border.color: "white"

        selectionEnabled: true

        height: (parent.height - buttonHeight) / 2
        width: application.buttonWidth * 3 + 40
    }

    MemberList {
        id: toSelector
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        selectionEnabled: true

        height: (parent.height - buttonHeight) / 2 + 10
        width: application.buttonWidth * 3 + 40

    }

    Text {
        anchors.bottom: toSelector.top
        anchors.horizontalCenter: toSelector.horizontalCenter
        font.pixelSize: fontSize
        text: "Transfer to"
        color: "white"
    }

    Text {
        anchors.top: fromSelector.bottom
        anchors.horizontalCenter: fromSelector.horizontalCenter
        font.pixelSize: fontSize
        text: "Transfer from"
        color: "white"
    }


    Item {
        id: rest
        anchors.left: parent.left
        anchors.right: fromSelector.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Text {
            id: pageTitle
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            font.pixelSize: 40
            color: "white"
            text: "Transfer"

        }

        NumberEntry {
            id: amount
            anchors.horizontalCenter: rest.horizontalCenter
            anchors.top: pageTitle.bottom
            anchors.topMargin: 10
        }


        GridLayout {

            property int colWidth: buttonWidth * 1.5 + 10

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            id: pendingDisplay
            columns: 2
            columnSpacing: 10
            width: colWidth * 2 + 10

            Text {
                Layout.alignment: Qt.AlignRight
                text: "Will transfer "
                horizontalAlignment: Text.AlignRight
                color: "white"
                font.pixelSize: application.fontSize
                font.family: application.fontFace
                width: pendingDisplay.colWidth
            }

            Text {
                text: application.formatCurrency(amount.value)
                color: "white"
                font.pixelSize: application.fontSize
                font.family: application.fontFace
                width: pendingDisplay.colWidth
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: "from "
                horizontalAlignment: Text.AlignRight
                font.pixelSize: application.fontSize
                font.family: application.fontFace
                color: "white"
                width: pendingDisplay.colWidth
            }

            Text {
                text: fromSelector.selectedName
                color: "white"
                font.pixelSize: application.fontSize
                font.family: application.fontFace
                width: pendingDisplay.colWidth
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: "to "
                horizontalAlignment: Text.AlignRight
                color: "white"
                font.pixelSize: application.fontSize
                font.family: application.fontFace
                width: pendingDisplay.colWidth
            }

            Text {
                text: toSelector.selectedName
                color: "white"
                font.pixelSize: fontSize
                font.family: application.fontFace
                width: pendingDisplay.colWidth
            }

            TqButton {
                implicitWidth: pendingDisplay.colWidth

                bgColor: Colors.secondary1[0]
                text: "Cancel"
                onClicked: {
                    console.log("cancel")
                    view.canceled()
                    reset()
                }
            }
            TqButton {
                implicitWidth: pendingDisplay.colWidth

                bgColor: Colors.secondary2[0]
                enabled: fromSelector.hasSelection && toSelector.hasSelection && amount.value > 0
                text: "Do it!"
                onClicked: {
                    accepted(fromSelector.selectedName, toSelector.selectedName, amount.value)
                    reset()
                }
            }
        }
    }


}
