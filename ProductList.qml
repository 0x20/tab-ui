import QtQuick 2.0
import QtQuick.Controls 2.0
import "controls"
Rectangle {
    color: "#004400"

    GridView {
        id: view
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10

        clip: true
        model: productModel
        cellWidth: 140
        cellHeight: cellWidth * (Math.sqrt(5) - 1) / 2

        delegate: TqButton {
            text: name
            width: view.cellWidth - 10
            height: view.cellHeight - 10

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
