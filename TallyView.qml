import QtQuick 2.0
import QtQuick.Layouts 1.3
import "Colors.js" as Colors
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
                    font.pixelSize: application.fontSize
                    font.family: application.fontFace
                }

                Text {
                    width: parent.width - qtyLabel.width - costLabel.width
                    color: "white"
                    text: name
                    font.pixelSize: application.fontSize
                    font.family: application.fontFace
                }
                Text {
                    id: costLabel
                    color: "white"
                    width: 100
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: application.fontSize
                    font.family: application.fontFace
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
            color: Colors.primary[4]

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
            font.pixelSize: application.fontSize
            font.family: application.fontFace
            text: "         Total: "
            width: parent.width - totalLabel.width
        }

        Text {
            id: totalLabel
            color: "white"

            width: 120
            font.pixelSize: application.fontSize
            font.family: application.fontFace
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
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        height: application.buttonHeight
        TqButton {
            text: "Cancel Transaction"
            enabled: tallyModel.count > 0
            bgColor: Colors.secondary1[0]
            onClicked: {
                tallyModel.clear()
            }
        }

        TqButton {
            anchors.right: parent.right
            anchors.margins: 0
            enabled: tally.hasSelection
            bgColor: Colors.secondary1[0]

            text: "Remove Item"
            onClicked: {
                tallyModel.adjustQuantity(tallyList.currentIndex, -1)
            }
        }
    }

}
