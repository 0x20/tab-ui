import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../Colors.js" as Colors

Item {

    property int value: absValue * (sign ? -1 : 1);
    property int absValue: 0
    property bool hasNegate: false
    property bool sign: false
    implicitWidth: padLayout.implicitWidth
    implicitHeight: padLayout.implicitHeight + fontSize + 30

    function addDigit(digit) {
        absValue = absValue * 10 + digit;
    }

    function reset() {
        sign = false;
        absValue = 0;
    }

    GridLayout {
        id: padLayout
        columns: 3
        columnSpacing: 10
        rowSpacing: 10

        Repeater {
            model: 9
            TqButton {
                text: index+1
                onClicked: addDigit(index+1)
            }
        }

        Rectangle {
            width: 1
            height: 1
            opacity: 0
            visible: !hasNegate
        }

        TqButton {
            text: "-"
            bgColor: "secondary2"
            onClicked: { sign = !sign }
            visible: hasNegate
        }
        TqButton {
            text: "0"
            onClicked: addDigit(0)
        }
        TqButton {
            text: "←"
            bgColor: Colors.secondary1[0]
            onClicked: { absValue = Math.floor(absValue / 10) }
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
