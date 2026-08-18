// modules/wifi/NetworkList.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../config" as Config
import "../../services" as Services
import "components" as Component

Item {
    id: root
    anchors.fill: parent

    Column {
        anchors.fill: parent
        spacing: 0

        Component.NetworkHeader {}

        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(1, 1, 1, 0.07)
        }

        Item {
            width: parent.width
            height: parent.height

            Component.NetworkRow {
                width: parent.width - 15
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 8
                anchors.leftMargin: 8
            }
        }

        Item {
            width: parent.width
            height: 160
            visible: Services.Network.scanning && Services.Network.networks.lenght === 0
            Component.ScanRings {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 12
                }
                width: 96
                height: 96
                centerGlyph: "󰤨"
                glyphSize: 18
            }
            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 8
                }
                text: "Scanning…"
                font.pixelSize: 11

                color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.5)
            }
        }
    }
}
