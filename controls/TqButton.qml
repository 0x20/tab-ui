import QtQuick 2.0
import QtQuick.Controls 2.2
import "../Colors.js" as Colors
Button {
    id: control
//    property string content: "Undefined"
//    text: { content.replace("&", "&&") }

    property string bgColor: Colors.primary[0]
    property string fgColor: "white"
    property int shade: 0
    property int downShade: 4

    palette.buttonText: "white"
    palette.light:(Colors.hasOwnProperty(bgColor)) ? Colors[bgColor][4] : Qt.lighter(bgColor)
    opacity: if (enabled) { return 1.0 } else { return 0.5 }
    font.family: application.fontFace
    font.pixelSize: application.fontSize
    implicitHeight: application.buttonHeight
    implicitWidth: application.buttonWidth
    anchors.margins: 10

    background: Rectangle {
        implicitHeight: application.buttonHeight
        implicitWidth: application.buttonWidth
        color: {
            if (Colors.hasOwnProperty(bgColor)) {
                Colors[bgColor][control.down ? downShade : shade]
            } else {
                control.down ? Qt.lighter(control.bgColor) : control.bgColor
            }
        }
    }

    contentItem: Text {
        font: control.font
        text: control.text
        color: control.fgColor
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

    }
}
