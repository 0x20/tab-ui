import QtQml 2.2
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.XmlListModel 2.0
import "controls"
import "http.js" as Http

Window {
    id: application
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property int fontSize: 20
    property int buttonWidth: 123
    property int buttonHeight: (Math.sqrt(5) - 1) / 2 * buttonWidth

    property string backend_url: Qt.application.arguments[1] || "http://localhost:4903"
    property bool layoutDebug: false

    function layoutColor(color) {
        if (layoutDebug) {
            return color;
        } else {
            return "black";
        }
    }

    StackLayout {
        width: 1024
        height: 768
        id: mainStack

        anchors.centerIn: parent

        currentIndex: 0

        MainView {
            id: mainView
        }
    }
    RowLayout {
        anchors.top: mainStack.bottom
        anchors.left: mainStack.left
        anchors.right: parent.right

        spacing: 10

        TqButton {
            text: "text-"
            onClicked: { fontSize -= 1 }
        }
        TqButton {
            text: "text+"
            onClicked: { fontSize += 1 }
        }
        Text {
            text: "font size: " + fontSize
            font.pixelSize: fontSize
        }
        TqButton {
            text: "Toggle layout debug"
            onClicked: layoutDebug = !layoutDebug
        }
    }

    Component.onCompleted: {
        loadAllData()
        console.log(application.buttonHeight)
    }

    ListModel {
        id: members

       function loadFromJson(json) {
           clear()
           for (var key in json) {
               var member = json[key]
               var converted_member= {
                   name: member["display_name"],
                   balance: member["balance"],
               }

//               console.log("Product " + JSON.stringify(key) + ": " + JSON.stringify(converted_member))
               append(converted_member)
           }
           // TODO: sort the list?
       }
    }

    ListModel {
        id: productModel

        function loadFromJson(json) {
            var items = []
            for (var key in json) {
                var product = json[key]
//                console.log("Product " + JSON.stringify(key) + ": " + JSON.stringify(product))
                items.push({
                       name: product.name,
                       cost: Math.round((product.price - 0) * 100),
                       category: product.category,
                       sort_key: product.sort_key,
                })
            }
            items.sort(function (a,b) { return a.sort_key.localeCompare(b.sort_key)});
            clear()
            for (var i = 0; i < items.length; i++) {
                append(items[i]);
            }

            // TODO: sort the list?
        }
    }

    ListModel {
        id: logModel
        ListElement {
            message: "foo"
        }
        ListElement {
            message: "bar"
        }

        function log(message) {
            append({message: message})
        }
    }

    ListModel {
        id: tallyModel

        function addItem(name, cost, qty) {
            qty = qty || 1;

            var found = false;
            for (var i = 0; i < count; i++) {
                var item = get(i);
                if (item.name === name) {
                    setProperty(i, "count", item.count + qty);
                    found = true;
                    break;
                }
            }
            if (!found) {
                append({
                           name: name,
                           cost: cost,
                           count: qty,
                       });
            }
        }

        property int total: {
            var total = 0
            for (var i = 0; i < count; i++) {
                var item = get(i)
                total = total + item.cost * item.count
            }
            return total
        }

        property int itemCount: {
            var total = 0
            for (var i = 0; i < count; i++) {
                var item = get(i)
                total = total + item.count
            }
            total
        }
    }

    function formatCurrency(cents) {
        var locale = Qt.locale("nl_BE");
        //var locale = Qt.locale("en_US");

        return (cents / 100).toLocaleCurrencyString(locale, "€ ")
    }

    function handlePurchase(name, bill) {
        var totalCost = 0
        var totalItems = 0

        for (var i = 0; i < bill.length; i++) {
            var item = bill[i]
            totalCost += item.cost * item.count
            totalItems += item.count
        }

        logModel.log(name + " bought " +
                     totalItems + " item" + (totalItems > 1 ? "s" : "") +
                     " for " + formatCurrency(totalCost))
        tallyModel.clear()
    }

    function loadAllData() {
        Http.get(backend_url + "/api/v1/accounts", function(xhr) {
            var json = JSON.parse(xhr.responseText)
            members.loadFromJson(json)
        })
        Http.get(backend_url + "/api/v1/products", function(xhr) {
            var json = JSON.parse(xhr.responseText)
            productModel.loadFromJson(json)
        })
    }
}
