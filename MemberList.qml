import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.11
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

    GridLayout {
        id: pagedGrid
        property int page: 0
        property int ncol: Math.floor(parent.width / (application.buttonWidth + 10))
        property int nrow: Math.floor(parent.height / (application.buttonHeight + 10))
        
        columns: ncol
        //anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
        //anchors.right: parent.right
        height: nrow * (application.buttonHeight + 10) - 10
        
        
        anchors.topMargin: 10
        anchors.leftMargin: 10
        //anchors.bottomMargin: 10
        //anchors.rightMargin: 10
        
        //anchors.fill: parent
        TqButton {
            text: "←"
            Layout.row: pagedGrid.nrow - 1
            onClicked: console.log(pagedGrid.nrow + ", " + pagedGrid.ncol)
        }
        
        Repeater {
            model: pagedGrid.nrow * pagedGrid.ncol - 2
            TqButton {
                property int row: index / pagedGrid.ncol
                
                Layout.row: row
                Layout.column: index % pagedGrid.ncol + (row == pagedGrid.nrow - 1 ? 1 : 0)
                text: index + ""
                bgColor: "complement"
                
            }
        }
    }
    
    GridView {
        clip: true
        visible: false
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
