import QtQuick 2.0

Rectangle {
    color: application.layoutColor("#202020")

    ListView {
        anchors.fill: parent
        model: logModel

        delegate: Text {
            //height: font.pointSize
            color: switch (status) {
                   case "pending": return "#aaaaaa";
                   case "confirmed": return "#ffffff";
                   case "failed": return "#FF0000";
                   default: return "#0088ff";
                   }

            text: {
                var ts_string = "<" + timestamp.toLocaleString(Qt.locale(), "yyyy/MM/dd  HH:mm:ss") + "> ";
                var suffix = "";

                switch (status) {
                    case "pending":
                        suffix = " (pending)";
                        break;
                    case "failed":
                        suffix = " (failed)";
                        break;
                    default: suffix = "";
                }

                return ts_string + message + suffix;
            }
            font.family: application.fontFace
            font.pixelSize: application.fontSize
        }
        onCountChanged: {
            currentIndex = count - 1
        }

    }
}
