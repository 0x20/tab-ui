import QtQuick 2.0

Rectangle {
    color: application.layoutColor("#202020")

    ListView {
        anchors.fill: parent
        model: logModel

        delegate: Text {
            //height: font.pointSize
            color: "white"
            text: message
            font.family: "monospace"
            font.pixelSize: application.fontSize
        }
        onCountChanged: {
            currentIndex = count - 1
        }

    }
}
