import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import "Colors.js" as Colors
import "controls"


Rectangle {
    color: application.layoutColor("#002244")

    signal selected(string name)
    property string selectedName: null
    property bool selectionEnabled: false
    property bool hasSelection: selectedName != ""

    Component {
        id: memberEntry

        TqButton {
            onClicked: {
                selectedName = internal_name;
                selected(internal_name)
            }

            bgColor: "primary"
            shade: (selectedName == internal_name && selectionEnabled) ? 4 : 0
            width: memberGrid.cellWidth - 10
            height: memberGrid.cellHeight - 10
            text: name
        }
    }

    GridView {
        clip: true
        id: memberGrid
        cellWidth: application.buttonWidth + 10
        cellHeight: application.buttonHeight + 10
        model: members
        delegate: memberEntry
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10
    }
}
