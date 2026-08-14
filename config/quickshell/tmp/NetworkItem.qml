// modules/wifi/NetworkItem.qml
import QtQuick
import Quickshell.Networking
import "../../widgets" as Widgets
import "../../config" as Config
import "../../services" as Services

Item {
    id: root

    required property var accessPoint
    required property bool isConnected

    property bool isExpanded: false
    property bool isForgetPending: false
    property bool isConnecting: false
    property bool showPassword: false

    width: parent?.width ?? 0
    height: baseRow.height + expandArea.height

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: root.isConnected
            ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07)
            : rowHover.hovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
        border.color: root.isConnected
            ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18)
            : Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
        Behavior on color { ColorAnimation { duration: 130 } }
        Behavior on border.color { ColorAnimation { duration: 130 } }
    }

    Item {
        id: baseRow
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 48

        Column {
            anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
            spacing: 3

            Widgets.StyledText {
                text: root.accessPoint?.name ?? ""
                font.pixelSize: 13
                font.bold: root.isConnected
                color: root.isConnected ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.7)
                width: 160
                elide: Text.ElideRight
            }

            Widgets.StyledText {
                visible: root.isConnected
                text: "Connected"
                font.pixelSize: 10
                color: Config.Theme.primary
            }
        }

        Row {
            anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
            spacing: 6

            Row {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: 4
                    Rectangle {
                        required property int index
                        width: 3
                        height: 4 + index * 3
                        radius: 1
                        anchors.bottom: parent.bottom
                        color: {
                            const s = root.accessPoint?.signalStrength ?? 0
                            const lit = (index === 0 && s > 0)
                                || (index === 1 && s > 25)
                                || (index === 2 && s > 50)
                                || (index === 3 && s > 75)
                            return lit
                                ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.85)
                                : Qt.rgba(1, 1, 1, 0.15)
                        }
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                }
            }

            Widgets.StyledText {
                visible: root.isConnecting
                text: "○"
                font.pixelSize: 14
                color: Config.Theme.primary
                anchors.verticalCenter: parent.verticalCenter
                SequentialAnimation on opacity {
                    running: root.isConnecting
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.2; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
            }

            Item {
                visible: root.isConnected
                width: 28; height: 28
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    anchors.fill: parent; radius: 6
                    color: dHov.hovered ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }
                Widgets.MaterialIcon {
                    anchors.centerIn: parent; text: "wifi_off"; font.pixelSize: 14
                    color: dHov.hovered ? Config.Theme.error : Qt.rgba(1, 1, 1, 0.35)
                    Behavior on color { ColorAnimation { duration: 100 } }
                }
                HoverHandler { id: dHov; cursorShape: Qt.PointingHandCursor }
                MouseArea { anchors.fill: parent; onClicked: root.accessPoint.disconnect() }
            }

            Item {
                visible: root.isConnected
                width: 28; height: 28
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    anchors.fill: parent; radius: 6
                    color: fHov.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.15) : "transparent"
                    Behavior on color { ColorAnimation { duration: 100 } }
                }
                Widgets.MaterialIcon {
                    anchors.centerIn: parent; text: "delete"; font.pixelSize: 13
                    color: fHov.hovered ? Config.Theme.error : Qt.rgba(1, 1, 1, 0.3)
                    Behavior on color { ColorAnimation { duration: 100 } }
                }
                HoverHandler { id: fHov; cursorShape: Qt.PointingHandCursor }
                MouseArea { anchors.fill: parent; onClicked: root.isForgetPending = !root.isForgetPending }
            }

            Rectangle {
                visible: !root.isConnected && !root.isConnecting
                anchors.verticalCenter: parent.verticalCenter
                width: connLbl.implicitWidth + 20; height: 28; radius: 8
                color: conHov.hovered
                    ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.22)
                    : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.09)
                border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                border.width: 1
                Behavior on color { ColorAnimation { duration: 100 } }
                Widgets.StyledText {
                    id: connLbl; anchors.centerIn: parent
                    text: root.isExpanded ? "Retry" : "Connect"
                    font.pixelSize: 11; color: Config.Theme.primary
                }
                HoverHandler { id: conHov; cursorShape: Qt.PointingHandCursor }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.isForgetPending = false
                        const secured = root.accessPoint?.security !== "none"
                            && root.accessPoint?.security !== ""
                        if (secured) {
                            root.isExpanded = !root.isExpanded
                        } else {
                            root.isConnecting = true
                            root.accessPoint.connectWithPsk("")
                        }
                    }
                }
            }
        }

        // tap on baseRow only to toggle expand
        TapHandler {
            enabled: !root.isConnected && !root.isConnecting
            onTapped: {
                root.isForgetPending = false
                const secured = root.accessPoint?.security !== "none"
                    && root.accessPoint?.security !== ""
                if (secured) root.isExpanded = !root.isExpanded
                else {
                    root.isConnecting = true
                    root.accessPoint.connectWithPsk("")
                }
            }
        }
    }

    Item {
        id: expandArea
        anchors { top: baseRow.bottom; left: parent.left; right: parent.right }
        clip: true
        height: (root.isForgetPending || root.isExpanded) ? 56 : 0
        Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        // forget confirm
        Rectangle {
            visible: root.isForgetPending
            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 8; leftMargin: 10; rightMargin: 10 }
            height: 40; radius: 8
            color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.07)
            border.color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.22)
            border.width: 1

            Row {
                anchors.centerIn: parent; spacing: 12
                Widgets.StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Forget this network?"; font.pixelSize: 11
                    color: Qt.rgba(1, 1, 1, 0.55)
                }
                Rectangle {
                    width: 54; height: 24; radius: 6
                    color: cfHov.hovered ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.04)
                    Behavior on color { ColorAnimation { duration: 80 } }
                    Widgets.StyledText { anchors.centerIn: parent; text: "Cancel"; font.pixelSize: 10; color: Qt.rgba(1, 1, 1, 0.45) }
                    HoverHandler { id: cfHov; cursorShape: Qt.PointingHandCursor }
                    MouseArea { anchors.fill: parent; onClicked: root.isForgetPending = false }
                }
                Rectangle {
                    width: 54; height: 24; radius: 6
                    color: ffHov.hovered
                        ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.35)
                        : Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18)
                    Behavior on color { ColorAnimation { duration: 80 } }
                    Widgets.StyledText { anchors.centerIn: parent; text: "Forget"; font.pixelSize: 10; color: Config.Theme.error }
                    HoverHandler { id: ffHov; cursorShape: Qt.PointingHandCursor }
                    MouseArea { anchors.fill: parent; onClicked: root.accessPoint.forget() }
                }
            }
        }

        // password input
        Rectangle {
            id: passRect
            visible: root.isExpanded && !root.isForgetPending
            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 8; leftMargin: 10; rightMargin: 10 }
            height: 40; radius: 8
            color: Qt.rgba(1, 1, 1, 0.06)
            border.color: passInput.activeFocus
                ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55)
                : Qt.rgba(1, 1, 1, 0.12)
            border.width: 1
            Behavior on border.color { ColorAnimation { duration: 120 } }

            Widgets.StyledText {
                anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                text: "Password…"; font.pixelSize: 12
                color: Qt.rgba(1, 1, 1, 0.22)
                visible: passInput.text === ""
            }

            TextInput {
                id: passInput
                anchors {
                    left: parent.left; leftMargin: 10
                    right: eyeBtn.left; rightMargin: 6
                    top: parent.top; bottom: parent.bottom
                }
                verticalAlignment: TextInput.AlignVCenter
                color: Config.Theme.surfaceOn
                font.pixelSize: 12
                echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
                clip: true
                selectByMouse: true
                Keys.onReturnPressed: {
                    if (text.length > 0) {
                        root.isConnecting = true
                        root.accessPoint.connectWithPsk(text)
                    }
                }
            }

            Item {
                id: eyeBtn
                anchors { right: parent.right; rightMargin: 4; verticalCenter: parent.verticalCenter }
                width: 28; height: 28
                Rectangle {
                    anchors.fill: parent; radius: 6
                    color: eyeHov.hovered ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                }
                Widgets.MaterialIcon {
                    anchors.centerIn: parent
                    text: root.showPassword ? "visibility_off" : "visibility"
                    font.pixelSize: 13
                    color: root.showPassword ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.28)
                }
                HoverHandler { id: eyeHov; cursorShape: Qt.PointingHandCursor }
                MouseArea { anchors.fill: parent; onClicked: root.showPassword = !root.showPassword }
            }
        }
    }

    onIsExpandedChanged: {
        if (isExpanded) Qt.callLater(() => passInput.forceActiveFocus())
        else passInput.text = ""
    }

    HoverHandler { id: rowHover; enabled: !root.isConnected }
}
