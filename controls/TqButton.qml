import QtQuick 2.0
import QtQuick.Controls 2.2
Button {
    id: control
//    property string content: "Undefined"
//    text: { content.replace("&", "&&") }

    property string bgColor: "#0088ff"
    property string fgColor: "white"

    palette.button: bgColor
    palette.buttonText: fgColor
    opacity: if (enabled) { return 1.0 } else { return 0.5 }
    font.family: "sans"
    font.pixelSize: application.fontSize
    implicitHeight: application.buttonHeight
    implicitWidth: application.buttonWidth
    anchors.margins: 10

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
