import QtQuick 2.0
import QtQuick.Controls 2.0
import "controls"
Rectangle {
    color: application.layoutColor("#004400")

    GridView {
        id: view
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10

        clip: true
        model: productModel
        cellWidth: application.buttonWidth + 10
        cellHeight: application.buttonHeight + 10

        delegate: TqButton {
            text: name
            width: application.buttonWidth
            height: application.buttonHeight

            bgColor: {
                switch(category) {
                case "food": return "#cc6600"
                case "alcohol": return "#efc026"
                case "drink": return "#880000"
                case "misc": return "#008800"
                case "swag": return "#880088"
                default: return "#444444"
                }
            }
            fgColor: {
                switch(category) {
                case "alcohol": return "black"
                default: return "white"
                }
            }

            onClicked: {
                tallyModel.addItem(name, cost, 1)
            }
        }
    }
}
