import QtQuick 2.0
import QtQuick.Controls 2.0
import QuickPromise 1.0
import "controls"
Rectangle {
    color: application.layoutColor("#004400")

    signal selected(int index, string name)
    property string selectedName: selectedIndex < 0 ? null : productModel.get(selectedIndex)["internal_name"]
    property bool selectionEnabled: false
    property bool hasSelection: selectedIndex != -1
    property int selectedIndex: -1

    property int page: 0
    property int _perPage: _nrow * _ncol - 2
    property int _maxPage: Math.ceil(productModel.count / (_nrow * _ncol - 2))
    property int _offset: page * _perPage
    property int _ncol: Math.floor(width / _cell_width)
    property int _nrow: Math.floor(height / _cell_height)
    property int _cell_width: application.buttonWidth + 10
    property int _cell_height: application.buttonHeight + 10
    
    
    TqButton {
        text: "←"
        x: 10
        y: (_nrow - 1) * _cell_height + 10
        onClicked: page -= 1
        enabled: page > 0
    }

    TqButton {
        text: "→"
        x: 10 + _cell_width * (_ncol - 1)
        y: (_nrow - 1) * _cell_height + 10
        onClicked: page += 1
        enabled: page < (_maxPage - 1)
    }

    Repeater {
        model: Math.min(productModel.count - _offset, _perPage)
        TqButton {
            property int _subindex: index
            property int _row: _subindex / _ncol
            property int _itemIdx: index + _offset
            
            property string category: productModel.get((productModel.dataGeneration, _itemIdx))["category"]
            
            x: (_subindex % _ncol + (_row == _nrow - 1 ? 1 : 0)) * _cell_width + 10
            y: _row * _cell_height + 10
            // This is a bit weird; we need to reference the data generation so that it 
            // updates when the model does
            text: productModel.get((productModel.dataGeneration, _itemIdx))["name"]
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
                var internal_name = productModel.get(_itemIdx)["internal_name"]
                selectedIndex = _itemIdx
                selected(selectedIndex, internal_name)
                
                console.log("maxpage: ", _maxPage)
            }
        }
    }
}
