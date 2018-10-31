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
    font.family: "sans"
    font.pixelSize: application.fontSize

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
