// modules/bluetooth/BluetoothList.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../config" as Config
import "../../services" as Services
import "components" as Components

Item {
    id: root
    anchors.fill: parent

    property var pairedDevices:    Services.Bluetooth.allDevices.filter(d => d.paired)
    property var availableDevices: Services.Bluetooth.allDevices.filter(d => !d.paired)

    Column {
        anchors.fill: parent
        anchors.margins: Config.Appearance.spacing.larger
        spacing: Config.Appearance.spacing.normal

        Components.BluetoothHeader {}

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
                contentHeight: deviceColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: deviceColumn
                    width: flick.width
                    spacing: 8

                    // scanning indicator
                    Item {
                        width: parent.width
                        height: 160
                        visible: Services.Bluetooth.scanning && Services.Bluetooth.allDevices.length === 0

                        Components.BluetoothScanRings {
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
                            color: Qt.rgba(Config.Theme.tertiary.r, Config.Theme.tertiary.g, Config.Theme.tertiary.b, 0.5)
                        }
                    }

                    // paired section
                    Column {
                        width: parent.width
                        spacing: Config.Appearance.spacing.small
                        visible: root.pairedDevices.length > 0

                        Text {
                            text: "PAIRED"
                            font.pixelSize: 9
                            font.bold: true
                            font.letterSpacing: 1.2
                            color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.5)
                        }

                        Repeater {
                            model: root.pairedDevices
                            delegate: Components.BluetoothBaseRow {
                                required property var modelData
                                width: deviceColumn.width
                                device: modelData
                                isPaired: true
                            }
                        }
                    }

                    // divider
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Qt.rgba(1, 1, 1, 0.07)
                        visible: root.pairedDevices.length > 0 && root.availableDevices.length > 0
                    }

                    // available section
                    Column {
                        width: parent.width
                        spacing: Config.Appearance.spacing.small
                        visible: root.availableDevices.length > 0

                        Text {
                            text: "AVAILABLE"
                            font.pixelSize: 9
                            font.bold: true
                            font.letterSpacing: 1.2
                            color: Qt.rgba(1, 1, 1, 0.25)
                        }

                        Repeater {
                            model: root.availableDevices
                            delegate: Components.BluetoothBaseRow {
                                required property var modelData
                                width: deviceColumn.width
                                device: modelData
                                isPaired: false
                            }
                        }
                    }

                    // no devices found
                    Item {
                        width: parent.width
                        height: 160
                        visible: !Services.Bluetooth.scanning && Services.Bluetooth.allDevices.length === 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "󰂲"
                                font.pixelSize: 34
                                color: Qt.rgba(1, 1, 1, 0.08)
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "No devices found"
                                font.pixelSize: 12
                                color: Qt.rgba(1, 1, 1, 0.2)
                            }
                        }
                    }

                    Item { width: parent.width; height: 8 }
                }
            }
        }
    }
}
