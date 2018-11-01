import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "controls"
import "Colors.js" as Colors

Rectangle {
    id: display
    signal canceled()

    color: "black"

    RowLayout {
       spacing: 10
       anchors.top: parent.top
       anchors.left: parent.left
       anchors.right: parent.right
       anchors.bottom: buttons.top

       ListView {
           model: members
           clip: true
           Layout.fillHeight: true
           Layout.fillWidth: true

           headerPositioning: ListView.OverlayHeader
           header: Row {
               width: parent.width
               spacing: 5
               z: 10

               Rectangle {
                   color: Colors.primary[4]
                   width: parent.width - itemHdr.width - balanceHdr.width - 10
                   height: fontSize + 10
                   Text {
                       anchors.margins: 5
                       anchors.fill: parent
                       text: "Name"
                       color: "white"
                       font.pixelSize: fontSize
                   }
               }

               Rectangle {
                   id: itemHdr
                   color: Colors.primary[4]
                   width: 100
                   height: fontSize + 10
                   Text {
                       anchors.margins: 5
                       anchors.fill: parent
                       text: "Items"
                       color: "white"
                       font.pixelSize: fontSize
                       horizontalAlignment: Text.AlignRight
                   }
               }

               Rectangle {
                   id: balanceHdr
                   color: Colors.primary[4]
                   width: 150
                   height: fontSize + 10
                   Text {
                       anchors.margins: 5
                       anchors.fill: parent
                       text: "Balance"
                       color: "white"
                       font.pixelSize: fontSize
                       horizontalAlignment: Text.AlignRight
                   }
               }
           }

           delegate: Row {
               width: parent.width
               Text {
                   width: parent.width - itemQty.width - balanceLbl.width
                   text: name
                   color: "white"
                   font.pixelSize: fontSize
               }

               Text {
                   id: itemQty
                   width: 100
                   text: items_bought
                   color: "white"
                   font.pixelSize: fontSize
                   horizontalAlignment: Text.AlignRight
               }

               Text {
                   width: 150
                   id: balanceLbl
                   text: formatCurrency(balance)
                   color: "white"
                   font.pixelSize: fontSize
                   horizontalAlignment: Text.AlignRight
               }

           }
       }
    }

    Row {
        id: buttons
        TqButton {
            text: "Back"
            bgColor: "secondary1"
            onClicked: display.canceled()
        }

        anchors.margins: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
