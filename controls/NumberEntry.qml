import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../Colors.js" as Colors

Item {

    property int value: 0
    property bool hasAccept: true
    implicitWidth: padLayout.implicitWidth
    implicitHeight: padLayout.implicitHeight + fontSize + 30

    signal accepted(int value)


    function addDigit(digit) {
        value = value * 10 + digit;
    }

    GridLayout {
        id: padLayout
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        TqButton {
            text: "1"
            onClicked: addDigit(1)
        }
        TqButton {
            text: "2"
            onClicked: addDigit(2)
        }
        TqButton {
            text: "3"
            onClicked: addDigit(3)
        }

        TqButton {
            text: "4"
            onClicked: addDigit(4)
        }
        TqButton {
            text: "5"
            onClicked: addDigit(5)
        }
        TqButton {
            text: "6"
            onClicked: addDigit(6)
        }

        TqButton {
            text: "7"
            onClicked: addDigit(7)
        }
        TqButton {
            text: "8"
            onClicked: addDigit(8)
        }
        TqButton {
            text: "9"
            onClicked: addDigit(9)
        }

        TqButton {
            text: "←"
            bgColor: Colors.secondary1[0]
            onClicked: { value = Math.floor(value / 10) }
        }
        TqButton {
            text: "0"
            onClicked: addDigit(0)
        }
        Item {}
    }

    Rectangle {
        color: Colors.complement[0]
        width: padLayout.width
        anchors.top: padLayout.bottom
        anchors.topMargin: 10
        anchors.left: padLayout.left
        anchors.right: padLayout.right
        height: fontSize + 20

        Text {
            horizontalAlignment: Text.AlignRight
            anchors.margins: {
                left: 10
                right: 10
                top: 10
                bottom: 10
            }
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: parent.width

            color: "white"
            font.pixelSize: application.fontSize
            text: application.formatCurrency(value)
        }
    }

}
