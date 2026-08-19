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
        spacing: Config.Appearance.spacing.normal
        Component.NetworkHeader {}

        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(1, 1, 1, 0.07)
        }

        Item {
            width: parent.width - 10
            height: parent.height
            anchors.topMargin: Config.Appearance.padding.small

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: width
                contentHeight: networkColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: true

                Column {
                    id: networkColumn
                    width: flick.width
                    spacing: 8

                    Repeater {
                        model: Services.Network.networks
                        delegate: Component.NetworkRow {
                            networkColumn: networkColumn
                        }
                    }
                }
            }
        }

        Item {
            width: parent.width
            height: 160
            visible: Services.Network.scanning && Services.Network.networks.lenght === 0
            Component.NetworkScanRings {
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
