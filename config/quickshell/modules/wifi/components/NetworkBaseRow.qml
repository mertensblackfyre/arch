pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root

    property bool isForgetPending: false
    property bool isExpanded: Services.Network.expandSsid === root.modelData.ssid
    property bool isConnecting: Services.Network.connectingTo === root.modelData.ssid
    property bool _showPass: false

    property var passInput

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    height: 48
    required property var modelData

    Row {
        anchors.left: parent.left
        anchors.leftMargin: Config.Appearance.padding.large
        anchors.verticalCenter: parent.verticalCenter
        spacing: Config.Appearance.spacing.normal

        Widgets.MaterialIcon {
            anchors.verticalCenter: parent.verticalCenter
            text: Services.Icons.getNetworkIcon(root.modelData.signal, root.modelData.secured)
            color: root.modelData.inUse ? Config.Theme.primary : Config.Theme.surfaceVariantOn
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Widgets.StyledText {
                font.pixelSize: Config.Appearance.font.size.normal + 2
                font.bold: root.modelData.inUse
                text: root.modelData.ssid
                color: root.modelData.inUse ? Config.Theme.primary : Config.Theme.surfaceOn
            }

            Widgets.StyledText {
                visible: root.modelData.inUse
                text: "Connected"
                font.pixelSize: 10
                color: Config.Theme.primary
            }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        // connecting spinner
        Widgets.StyledText {
            visible: root.isConnecting
            text: "○"
            font.pixelSize: 14
            color: Config.Theme.primary
            anchors.verticalCenter: parent.verticalCenter
            SequentialAnimation on opacity {
                running: root.isConnecting
                loops: Animation.Infinite
                NumberAnimation {
                    to: 0.2
                    duration: 500
                }
                NumberAnimation {
                    to: 1.0
                    duration: 500
                }
            }
        }

        // Disconnect Button
        Item {
            visible: root.modelData.inUse
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter

            Widgets.IconButton {
                iconText: "wifi_off"
                pixelSize: 14
                onClicked: Services.Network.disconnect()
            }
        }

        // Forget Button
        Item {
            visible: root.modelData.inUse
            width: 28
            height: 28
            anchors.verticalCenter: parent.verticalCenter

            Widgets.IconButton {
                active: root.isForgetPending

                rectColor: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.15)
                rectFallbackColor: "transparent"

                iconColor: Config.Theme.error
                iconFallbackColor: Qt.rgba(1, 1, 1, 0.3)

                iconText: "delete"
                pixelSize: 13
                customRadius: 6

                onClicked: Services.Network.forget(root.modelData.ssid)
            }
        }

        // connect button
        Rectangle {
            visible: !root.modelData.inUse && !root.isConnecting
            anchors.verticalCenter: parent.verticalCenter
            width: connectLbl.implicitWidth + 20
            height: 28
            radius: 8
            color: conH.hovered ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.22) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.09)
            border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
            border.width: 1
            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }
            Widgets.StyledText {
                id: connectLbl
                anchors.centerIn: parent
                text: root.isExpanded ? "Retry" : "Connect"
                font.pixelSize: 11
                color: Config.Theme.primary
            }
            HoverHandler {
                id: conH
                cursorShape: Qt.PointingHandCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.isForgetPending = false;
                    if (root.isExpanded && root.passInput.text !== "") {
                        Services.Network.connectWithPassword(root.modelData.ssid, root.passInput.text);
                    } else {
                        Services.Network.connectFirst(root.modelData.ssid);
                    }
                }
            }
        }
    }
}
