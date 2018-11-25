import QtQuick 2.4
import "Colors.js" as Colors
import "controls"

Rectangle {
    color: "black"

    signal retry()
    
    property double progress: 0.5
    property string message: "Loading"

    Rectangle {
        id: progressBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.verticalCenter
        height: 20
        color: Colors.primary[1]
    }

    Rectangle {
        anchors.left: progressBar.left
        anchors.top: progressBar.top
        anchors.bottom: progressBar.bottom
        width: progressBar.width * progress
        color: Colors.primary[4]
    }

    Text {
        anchors.bottom: progressBar.top
        anchors.horizontalCenter: parent.horizontalCenter

        font.pixelSize: 50
        font.family: "TheQuux"
        text: message
        color: "white"
    }
    
    TqButton {
        anchors.horizontalCenter: progressBar.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        text: "retry"
        onClicked: retry()
        // We don't have this hooked up to anything...
        visible: false
    }
}
