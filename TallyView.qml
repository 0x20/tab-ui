import QtQuick 2.0
import QtQuick.Layouts 1.3
import "controls"

Rectangle {
    id: tally
    color: application.layoutColor("#440000")

    property bool hasSelection: tallyList.currentIndex !== -1

    ListView {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: totalRow.top
        }


        id: tallyList
        model: tallyModel
        clip: true

        delegate: MouseArea {
            width: parent.width
            height: itemRow.height
            Row {
                id: itemRow
                width: parent.width
                Text {
                    id: qtyLabel
                    color: "white"
                    width: 50
                    horizontalAlignment: Text.AlignRight
                    text: (count > 1) ? (count + "x ") : ""
                    font.pixelSize: 20
                    font.family: "sans"
                }

                Text {
                    width: parent.width - qtyLabel.width - costLabel.width
                    color: "white"
                    text: name
                    font.pixelSize: 20
                    font.family: "sans"
                }
                Text {
                    id: costLabel
                    color: "white"
                    width: 100
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 20
                    font.family: "monospace"
                    text: {
                        application.formatCurrency(cost * count)
                    }
                }
            }
            onClicked: {
                tallyList.currentIndex = index
                console.log("sel index: " + tallyList.currentIndex)
            }
        }

        onCountChanged: {
            currentIndex = count - 1
            currentIndex = -1
        }

        highlight: Rectangle {
            color: "#88ccff"

        }

        focus: true


    }
    Row {
        id: totalRow
        anchors {
            right: parent.right
            left: parent.left
            bottom: controls.top
        }

        Text {
            color: "white"
            font.pixelSize: 20
            font.family: "sans"
            text: "         Total: "
            width: parent.width - totalLabel.width
        }

        Text {
            id: totalLabel
            color: "white"

            width: 120
            font.pixelSize: 20
            font.family: "monospace"
            horizontalAlignment: Text.AlignRight

            text: {
                application.formatCurrency(tallyModel.total)
            }
        }
    }

    Item {
        id: controls
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        height: application.buttonHeight
        TqButton {
            text: "Cancel"
        }

        TqButton {
            anchors.right: parent.right
            anchors.margins: 0
            enabled: tally.hasSelection

            text: "Remove Item"
        }
    }

}
