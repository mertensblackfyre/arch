// modules/bluetooth/components/BluetoothBaseRow.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root

    required property var device
    required property bool isPaired

    readonly property bool isConnected: device.connected
    readonly property bool inAction: Services.Bluetooth.actionMac === device.mac
    readonly property bool inRemove: Services.Bluetooth.removingMac === device.mac
    readonly property bool isPairingOpen: Services.Bluetooth.pairingMac === device.mac
    readonly property bool isRemovePending: Services.Bluetooth.removeMac === device.mac

    width: parent?.width ?? 0
    height: 50

    Rectangle {
        anchors.fill: parent
        radius: Config.Appearance.rounding.small
        color: root.isConnected ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07) : rowHov.hovered && !root.isPaired ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
        border.color: root.isConnected ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18) : root.isRemovePending ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.22) : Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
        Behavior on color {
            ColorAnimation {
                duration: 130
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: 130
            }
        }
    }

    // device icon
    Widgets.StyledText {
        anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
        }
        text: Services.Bluetooth.glyph(root.device.iconType)
        font.pixelSize: 18
        color: root.isConnected ? Config.Theme.primary : (root.inAction || root.inRemove) ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.5) : Qt.rgba(1, 1, 1, 0.32)
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    // name + status
    Column {
        anchors {
            left: parent.left
            leftMargin: 44
            verticalCenter: parent.verticalCenter
        }
        spacing: 3

        Widgets.StyledText {
            text: root.device.name
            font.pixelSize: 13
            font.bold: root.isConnected
            color: root.isConnected ? Config.Theme.surfaceOn : Qt.rgba(1, 1, 1, 0.68)
            width: 160
            elide: Text.ElideRight
        }

        Widgets.StyledText {
            visible: root.isConnected || root.inAction || root.inRemove
            text: root.inRemove ? "Removing…" : root.inAction ? "Working…" : "Connected"
            font.pixelSize: 10
            color: (root.inAction || root.inRemove) ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55) : Config.Theme.primary
        }
    }

    // right side actions
    Row {
        anchors {
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
        spacing: 6

        // spinner
        Widgets.StyledText {
            visible: root.inAction || root.inRemove
            text: "○"
            font.pixelSize: 15
            color: Config.Theme.primary
            anchors.verticalCenter: parent.verticalCenter
            SequentialAnimation on opacity {
                running: root.inAction || root.inRemove
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.15
                    duration: 450
                }
                NumberAnimation {
                    to: 1.0
                    duration: 450
                }
            }
        }

        // paired: connect/disconnect pill
        Rectangle {
            visible: root.isPaired && !root.inAction && !root.inRemove
            anchors.verticalCenter: parent.verticalCenter
            width: togContent.implicitWidth + 20
            height: 28
            radius: 14
            color: root.isConnected ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.14) : togH.hovered ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.04)
            border.color: root.isConnected ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.36) : Qt.rgba(1, 1, 1, 0.11)
            border.width: 1
            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }

            Row {
                id: togContent
                anchors.centerIn: parent
                spacing: 7

                Rectangle {
                    width: 7
                    height: 7
                    radius: 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.isConnected ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.25)
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                Widgets.StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.isConnected ? "Connected" : "Connect"
                    font.pixelSize: 11
                    font.bold: true
                    color: root.isConnected ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.48)
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }
            }

            HoverHandler {
                id: togH
                cursorShape: Qt.PointingHandCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: root.isConnected ? Services.Bluetooth.disconnect(root.device.mac) : Services.Bluetooth.connect(root.device.mac)
            }
        }

        // paired: remove button
        Item {
            visible: root.isPaired && !root.inAction && !root.inRemove
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: 7
                color: rmH.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.20) : root.isRemovePending ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.12) : "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }

            Widgets.MaterialIcon {
                anchors.centerIn: parent
                text: "delete"
                font.pixelSize: 13
                color: (rmH.hovered || root.isRemovePending) ? Config.Theme.error : Qt.rgba(1, 1, 1, 0.25)
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }

            HoverHandler {
                id: rmH
                cursorShape: Qt.PointingHandCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Services.Bluetooth.removeMac = root.isRemovePending ? "" : root.device.mac
            }
        }

        // available: pair + pin buttons
        Row {
            visible: !root.isPaired && !root.inAction
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            // pair button
            Rectangle {
                width: pairLbl.implicitWidth + 20
                height: 28
                radius: 8
                color: pairH.hovered ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.22) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.09)
                border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                border.width: 1
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Widgets.StyledText {
                    id: pairLbl
                    anchors.centerIn: parent
                    text: "Pair"
                    font.pixelSize: 11
                    color: Config.Theme.primary
                }

                HoverHandler {
                    id: pairH
                    cursorShape: Qt.PointingHandCursor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Services.Bluetooth.removeMac = "";
                        Services.Bluetooth.pairingMac = "";
                        Services.Bluetooth.pair(root.device.mac, "");
                    }
                }
            }

            // pin button
            Item {
                width: 28
                height: 28
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: pinH.hovered ? Qt.rgba(1, 1, 1, 0.10) : root.isPairingOpen ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.12) : Qt.rgba(1, 1, 1, 0.04)
                    border.color: root.isPairingOpen ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.30) : Qt.rgba(1, 1, 1, 0.09)
                    border.width: 1
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                Widgets.MaterialIcon {
                    anchors.centerIn: parent
                    text: "lock"
                    font.pixelSize: 12
                    color: root.isPairingOpen ? Config.Theme.primary : pinH.hovered ? Qt.rgba(1, 1, 1, 0.7) : Qt.rgba(1, 1, 1, 0.28)
                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                HoverHandler {
                    id: pinH
                    cursorShape: Qt.PointingHandCursor
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Services.Bluetooth.removeMac = "";
                        Services.Bluetooth.pairingMac = root.isPairingOpen ? "" : root.device.mac;
                    }
                }
            }
        }
    }

    HoverHandler {
        id: rowHov
        enabled: !root.isPaired
    }
}
