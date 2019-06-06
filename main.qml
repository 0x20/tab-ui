import QtQml 2.2
import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QuickPromise 1.0
import com.thequux.tab 1.0
import "controls"
import "http.js" as Http

Window {
    id: application
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property int fontSize: 16
    property string fontFace: fontFaceInput.text

    property int buttonWidth: 123
    property int buttonHeight: (Math.sqrt(5) - 1) / 2 * buttonWidth

    property string backend_url: Qt.application.arguments[1] || "http://localhost:4903"
    property bool layoutDebug: false

    Timer {
        interval: 3600000 // hourly
        repeat: true
        running: true
        onTriggered: {
            var date = new Date();
            if (date.getDay() == 0 && date.getMonth() == 3) {
                application.fontFace = "Comic Sans MS"
            } else {
                application.fontFace = fontFaceInput.text
            }
        }
    }

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

        state: "loading"

        MainView {
            id: mainView
            onSwitchToTransfer: {
                mainStack.state = "transfer"
            }
            onSwitchToStats: {
                mainStack.state = "stats"
            }

            onPurchaseCommand: {
                application.handlePurchase(member, bill)
            }

            onDepositCommand: {
                performTxn(member + " deposited € " + (amount / 100).toFixed(2),
                           "deposit", {
                              member: member,
                              amount: (amount / 100).toFixed(2),
                          });

            }
        }

        TransferView {
            id: transferView
            onAccepted: {
                // from, to, amount
                performTxn(from + " gave " + to + " " + formatCurrency(amount),
                           "xfer", {
                               payer: from,
                               payee: to,
                               amount: (amount / 100).toFixed(2),
                           });
                mainStack.state = "main"
                reset()
            }
            onCanceled: {
                mainStack.state = "main"
                reset()
            }
        }

        StatsView {
            id: statsView
            onCanceled: mainStack.state = "main"
        }

        LoadingView {
            id: loadingView
            
            Timer {
                id: reloadTimer
                interval: 5000
            }
        }

        states: [
            State {
                name: "main"
                PropertyChanges {
                    target: mainStack
                    currentIndex: 0
                }
            },
            State {
                name: "transfer"
                PropertyChanges {
                    target: mainStack
                    currentIndex: 1
                }
            },
            State {
                name: "stats"
                PropertyChanges {
                    target: mainStack
                    currentIndex: 2
                }
            },
            State {
                name: "loading"
                PropertyChanges {
                    target: mainStack
                    currentIndex: 3
                }
                PropertyChanges {
                    target: loadingView
                    progress: 0
                    message: "Loading"
                }
            }

        ]
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
        TextInput {
            id: fontFaceInput
            text: "Roboto"
        }
    }

    Component.onCompleted: {
        loadAllData()
    }

    MemberModel {
        id: members
        
        property int dataGeneration: 0
        
        onDataChanged: {
            dataGeneration++
        }
    }

    ListModel {
        id: productModel
        
        property int dataGeneration: 0
        
        onDataChanged: {
            dataGeneration += 1
        }

        function loadFromJson(json) {
            var items = [];
            for (var key in json) {
                var product = json[key]
                items.push({
                       internal_name: key,
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
        }
    }

    ListModel {
        id: logModel

        function log(message) {
            logPending(message).confirm()
        }

        function logPending(message) {
            var i = count;
            var timestamp = new Date()
            append({
                       message: message,
                       status: "pending",
                       timestamp: timestamp,
                   })
            return {
                confirm: function(newMessage) {
                    if (newMessage) {
                        set(i, {
                                message: newMessage,
                                status: "confirmed",
                                timestamp: timestamp,
                            });
                    } else {
                        setProperty(i, "status", "confirmed");
                    }
                },
                fail: function() {
                    setProperty(i, "status", "failed")
                },
            }
        }
    }

    ListModel {
        id: tallyModel

        function addItem(currency, name, cost, qty) {
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
                           currency: currency,
                           name: name,
                           cost: cost,
                           count: qty,
                       });
            }
        }

        function adjustQuantity(currency, qty) {
            var index = currency;
            var item;
            if (currency instanceof String) {
                var found = false;
                for (var i = 0; i < count; i++) {
                    item = get(i);
                    if (item.currency === currency) {
                        index = i;
                        found = true;
                        break;

                    }
                }
                if (!found) {
                    return false;
                }
            } else if (index < 0 || index >= count) {
                return false;
            } else {
                item = get(index);
            }

            if (item.count + qty <= 0) {
                remove(index);
            } else {
                setProperty(index, "count", item.count + qty);
            }
            return true;
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

        return "€ " + (cents / 100).toFixed(2)

    }

    function handlePurchase(name, bill) {
        var totalCost = 0
        var totalItems = 0

        var req = {
            member: name,
            products: {},
        };
        var displayName = members.get(name).name;

        for (var i = 0; i < bill.length; i++) {
            var item = bill[i]
            req.products[item.currency] =
                    (req.products[item.currency] || 0) + item.count;
            totalCost += item.cost * item.count
            totalItems += item.count
        }

        performTxn(displayName + " bought " + totalItems + " item" +
                   (totalItems > 1 ? "s" : "") + " for " + formatCurrency(totalCost),
                   "buy", req);

        tallyModel.clear()
    }

    function performTxn(logMsg, type, req) {
        var logEntry = logModel.logPending(logMsg);
        Http.post(backend_url + "/api/v1/txn/" + type, req).then(function(xhr) {
            var json = JSON.parse(xhr.responseText);
            for (var member_name in json.members) {
                var member = json.members[member_name];
                members.applyDelta(member_name, Math.round(member.balance * 100), member.items)
            }
            logEntry.confirm(json.message);
        }, function(xhr) {
            // rejected
            logEntry.fail();
            logModel.log("Failed to commit transaction: " + xhr.status + " " + xhr.statusText).fail();
        });
    }

    function loadAllData(refresh) {
        mainStack.state = "loading";
        var loadLevel = 0;
        var maxLoad = 3;
        function incrLoadLevel() {
            loadLevel += 1;
            loadingView.progress = loadLevel / maxLoad;
        }

        function doReload() {
            var accounts = Http.get(backend_url + "/api/v1/accounts").then(function(xhr) {
                var json = JSON.parse(xhr.responseText)
                members.loadFromJson(json)
                incrLoadLevel();
                return true;
            });
            var products = Http.get(backend_url + "/api/v1/products").then(function(xhr) {
                console.log("here");
                var json = JSON.parse(xhr.responseText)
                console.log("Adding items " + JSON.stringify(json));
                productModel.loadFromJson(json)
                incrLoadLevel();
                return true;
            });
            return Q.all([accounts, products]);
        }

        var start_url;
        if (refresh) {
            start_url = application.backend_url + "/api/v1/admin/update";
        } else {
            start_url = application.backend_url + "/api/v1/ping";
        }
        
        function doStart() {
            loadingView.message = "Waiting for server";
            return Http.get(start_url).then(function() {
                loadingView.message = "Loading...";
                incrLoadLevel();
                return doReload()
            }).then(null, function() {
                loadingView.message = "Failed";
                return new Q.Promise(function(resolve, reject) { 
                    console.log("here");
                    Q.setTimeout(function() {resolve(true)}, 5000);

                }).then(doStart);
            });
        }
        
        doStart().then(function() {
            mainStack.state = "main";
        });
    }
}
