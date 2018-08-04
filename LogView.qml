import QtQuick 2.0

Rectangle {
    color: "#202020"

    ListView {
        anchors.fill: parent
        model: logModel

        delegate: Text {
            //height: font.pointSize
            color: "white"
            text: message
            font.family: "monospace"
        }
        onCountChanged: {
            currentIndex = count - 1
        }

    }
}
