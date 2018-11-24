import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../Colors.js" as Colors

Item {

    property int value: (sign ? -1 : 1) * absValue
    // position is the offset from cents of the digit we're adding
    // It can be 2, to enter units, 1 for 10c, 0 for 1c, 
    // or -1 for at the end (in which case button presses do
    // nothing)
    property int position: 2
    property int absValue: 0
    property bool hasNegate: false
    property bool sign: false
    implicitWidth: padLayout.implicitWidth
    implicitHeight: padLayout.implicitHeight + fontSize + 30

    function addDigit(digit) {
        if (position == 2) {
            absValue = absValue * 10 + digit * 100;
        } else if (position > -1) {
            absValue = absValue + digit * Math.pow(10, position);
            position--;
        } else if (position == -1) {
            // do nothing
        }
        
        console.log("<" + application.formatCurrency(value) + ">")
    }

    function backspace() {
        if (position == 2) {
            absValue = absValue / 10
            absValue -= absValue % 100
        } else {
            position++;
            absValue -= absValue % Math.pow(10, position+1);
        }
    }
    
    function reset() {
        sign = false;
        position = 2;
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
                enabled: position >= 0
            }
        }

        
        TqButton {
            Layout.row: 4
            Layout.column: 0
            text: "."
            bgColor: "secondary2"
            onClicked: if (position == 2) {
                position = 1
            }
            enabled: position == 2
            //visible: hasNegate
        }
        TqButton {
            Layout.row: 4
            Layout.column: 1
            text: "0"
            onClicked: addDigit(0)
            enabled: position >= 0
        }
        TqButton {
            Layout.row: 4
            Layout.column: 2
            text: "←"
            bgColor: Colors.secondary1[0]
            onClicked: backspace()
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
            font.family: "monospace"
            text: {
                var rawText = application.formatCurrency(value)
                rawText.substring(0, rawText.length - position - 1) + "   ".substr(2 - position)
            }
        }
    }

}
