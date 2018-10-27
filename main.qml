import QtQml 2.2
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.XmlListModel 2.0

Window {
    id: application
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property string url: Qt.application.arguments[1] || "http://localhost:4903"

    StackLayout {
        width: 1024
        height: 768

        anchors.centerIn: parent

        currentIndex: 0

        MainView {
            id: mainView
        }
    }

    Component.onCompleted: {
        loadAllData()
    }

    XmlListModel {
        id: members

       source: "data.xml"
       query: "/tab/members/member"

       XmlRole { name: "name"; query: "string(@name)" }
    }

    XmlListModel {
        id: productModel
        source: "data.xml"
        query: "/tab/products/product"

        XmlRole { name: "name"; query: "string(@name)" }
        XmlRole { name: "cost"; query: "number(@cost)" }
        XmlRole { name: "category"; query: "string(@category)" }

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

        function total() {
            var total = 0
            for (var i = 0; i < count; i++) {
                var item = get(i)
                total = total + item.cost * item.count
            }
            return total
        }

        function itemCount() {
            var total = 0
            for (var i = 0; i < count; i++) {
                var item = get(i)
                total = total + item.count
            }
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
        console.log(JSON.stringify(url))
    }
}
