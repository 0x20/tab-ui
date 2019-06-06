import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11
import "Colors.js" as Colors
import "controls"


Rectangle {
    id: control

    signal selected(string name)
    property string selectedName: selectedIndex < 0 ? null : members.get(selectedIndex)["internal_name"]
    property bool selectionEnabled: false
    property bool hasSelection: selectedIndex != -1
    property int selectedIndex: -1

    color: application.layoutColor("#002244")

    property int page: 0
    property int _perPage: _nrow * _ncol - 2
    property int _maxPage: Math.ceil(members.count / (_nrow * _ncol - 2))
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
        enabled: page < _maxPage - 1
    }

    Repeater {
        model: Math.min(members.count - _offset, _perPage)
        TqButton {
            property int _subindex: index
            property int _row: _subindex / _ncol
            property int _itemIdx: index + _offset
            
            x: (_subindex % _ncol + (_row == _nrow - 1 ? 1 : 0)) * _cell_width + 10
            y: _row * _cell_height + 10
            // This is a bit weird; we need to reference the data generation so that it 
            // updates when the model does
            text: members.get((members.dataGeneration, _itemIdx))["name"]
            // bgColor: (members.get((members.dataGeneration, _itemIdx))["name"] === "--CASH--" || members.get((members.dataGeneration, _itemIdx))["balance"] >= 0) ? "primary" : "secondary1"
            bgColor: {
                if (members.get((members.dataGeneration, _itemIdx))["name"] === "--CASH--") {
                    return "secondary2";
                } else if (members.get((members.dataGeneration, _itemIdx))["balance"] >= 0) {
                    return "primary"
                } else {
                    return"secondary1"
                }
            }
            shade: (selectedIndex == _itemIdx && selectionEnabled) ? 4 : 0
            
            onClicked: {
                var internal_name = members.get(_itemIdx)["internal_name"]
                selectedIndex = _itemIdx
                selected(internal_name)
            }
        }
    }
}
