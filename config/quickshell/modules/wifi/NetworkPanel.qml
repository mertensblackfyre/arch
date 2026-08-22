// modules/wifi/NetworkList.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../config" as Config
import "../../services" as Services
import "components" as Components

Item {
    id: root
    anchors.fill: parent

    property var connectedNetworks: Services.Network.networks.filter(n => n.inUse)
    property var availableNetworks: Services.Network.networks.filter(n => !n.inUse)

    Column {
        anchors.fill: parent
        anchors.margins: Config.Appearance.spacing.larger
        spacing: Config.Appearance.spacing.normal

        Components.NetworkHeader {}

        Rectangle {
            width: parent.width
            height: 1
            color: Qt.rgba(1, 1, 1, 0.07)
        }

        Item {
            width: parent.width
            height: parent.height - y

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: width
                contentHeight: networkColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: networkColumn
                    width: flick.width
                    spacing: 8

                    Item {
                        width: parent.width
                        height: 160
                        visible: Services.Network.scanning && Services.Network.networks.length === 0

                        Components.NetworkScanRings {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 12
                            width: 96
                            height: 96
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 8
                            text: "Scanning…"
                            font.pixelSize: 11
                            color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.5)
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Config.Appearance.spacing.small
                        visible: root.connectedNetworks.length > 0

                        Text {
                            text: "CONNECTED"
                            font.pixelSize: 9
                            font.bold: true
                            font.letterSpacing: 1.2
                            color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.5)
                        }

                        Repeater {
                            model: root.connectedNetworks
                            delegate: Components.NetworkRow {
                                networkColumn: networkColumn
                            }
                        }
                    }

                    Column {
                        width: parent.width
                        spacing: Config.Appearance.spacing.small
                        visible: root.availableNetworks.length > 0

                        Text {
                            text: "AVAILABLE"
                            font.pixelSize: 9
                            font.bold: true
                            font.letterSpacing: 1.2
                            color: Qt.rgba(1, 1, 1, 0.25)
                        }

                        Repeater {
                            model: root.availableNetworks
                            delegate: Components.NetworkRow {
                                networkColumn: networkColumn
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: 160
                        visible: !Services.Network.scanning && Services.Network.networks.length === 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "󰤭"
                                font.pixelSize: 34
                                color: Qt.rgba(1, 1, 1, 0.08)
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "No networks found"
                                font.pixelSize: 12
                                color: Qt.rgba(1, 1, 1, 0.2)
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: 8
                    }
                }
            }
        }
    }
}
