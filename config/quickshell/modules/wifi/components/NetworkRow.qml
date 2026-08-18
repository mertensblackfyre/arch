pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root
    implicitHeight: flick.contentHeight

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: networkColumn.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        interactive: true
        Keys.forwardTo: [passInput]

        Column {
            id: networkColumn
            width: flick.width
            spacing: 8

            Repeater {
                model: Services.Network.networks
                delegate: Item {
                    required property var modelData
                    required property int index

                    property bool isForgetPending: false
                    property bool isExpanded: Services.Network.expandSsid === modelData.ssid
                    property bool isConnecting: Services.Network.connectingTo === modelData.ssid
                    property bool _showPass: false

                    width: networkColumn.width
                    height: baseRow.height + expandArea.height

                    Rectangle {
                        anchors.fill: parent
                        radius: Config.Appearance.rounding.small
                        border.width: 1
                        color: modelData.inUse ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07) : rHov.hovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
                        border.color: modelData.inUse ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18) : Qt.rgba(1, 1, 1, 0.06)
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

                    // main row
                    Item {
                        id: baseRow
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                        height: 48

                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: Config.Appearance.padding.large
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: Config.Appearance.spacing.normal

                            Widgets.MaterialIcon {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Services.Icons.getNetworkIcon(modelData.signal, modelData.secured)
                                color: modelData.inUse ? Config.Theme.primary : Config.Theme.surfaceVariantOn
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Widgets.StyledText {
                                    font.pixelSize: Config.Appearance.font.size.normal + 2
                                    font.bold: modelData.inUse
                                    text: modelData.ssid
                                    color: modelData.inUse ? Config.Theme.primary : Config.Theme.surfaceOn
                                }

                                Widgets.StyledText {
                                    visible: modelData.inUse
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
                                visible: isConnecting
                                text: "○"
                                font.pixelSize: 14
                                color: Config.Theme.primary
                                anchors.verticalCenter: parent.verticalCenter
                                SequentialAnimation on opacity {
                                    running: isConnecting
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

                            // disconnect
                            Item {
                                visible: modelData.inUse
                                width: 28
                                height: 28
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 6
                                    color: dH.hovered ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                                Widgets.MaterialIcon {
                                    anchors.centerIn: parent
                                    text: "wifi_off"
                                    font.pixelSize: 14
                                    color: dH.hovered ? Qt.rgba(1, 1, 1, 0.65) : Qt.rgba(1, 1, 1, 0.35)
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                                HoverHandler {
                                    id: dH
                                    cursorShape: Qt.PointingHandCursor
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Services.Network.disconnect()
                                }
                            }

                            // forget
                            Item {
                                visible: modelData.inUse
                                width: 28
                                height: 28
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    anchors.fill: parent
                                    radius: 6
                                    color: fH.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.15) : isForgetPending ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.10) : "transparent"
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
                                    color: (fH.hovered || isForgetPending) ? Config.Theme.error : Qt.rgba(1, 1, 1, 0.3)
                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 100
                                        }
                                    }
                                }
                                HoverHandler {
                                    id: fH
                                    cursorShape: Qt.PointingHandCursor
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: isForgetPending = !isForgetPending
                                }
                            }

                            // connect button
                            Rectangle {
                                visible: !modelData.inUse && !isConnecting
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
                                    text: isExpanded ? "Retry" : "Connect"
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
                                        isForgetPending = false;
                                        if (isExpanded && passInput.text !== "") {
                                            Services.Network.connectWithPassword(modelData.ssid, passInput.text);
                                        } else {
                                            Services.Network.connectFirst(modelData.ssid);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // expand area
                    Item {
                        id: expandArea
                        anchors {
                            top: baseRow.bottom
                            left: parent.left
                            right: parent.right
                        }
                        clip: true
                        height: isForgetPending ? forgetRow.implicitHeight + 16 : isExpanded ? passRow.implicitHeight + 16 : 0
                        Behavior on height {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }

                        // forget confirm
                        Item {
                            id: forgetRow
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                topMargin: 8
                            }
                            implicitHeight: 32
                            opacity: isForgetPending ? 1 : 0
                            visible: opacity > 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            Rectangle {
                                anchors {
                                    fill: parent
                                    leftMargin: 10
                                    rightMargin: 10
                                }
                                radius: 8
                                color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.07)
                                border.color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.22)
                                border.width: 1

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 12

                                    Widgets.StyledText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "Forget this network?"
                                        font.pixelSize: 11
                                        color: Qt.rgba(1, 1, 1, 0.55)
                                    }

                                    Rectangle {
                                        width: 54
                                        height: 24
                                        radius: 6
                                        color: cfH.hovered ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.04)
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 80
                                            }
                                        }
                                        Widgets.StyledText {
                                            anchors.centerIn: parent
                                            text: "Cancel"
                                            font.pixelSize: 10
                                            color: Qt.rgba(1, 1, 1, 0.45)
                                        }
                                        HoverHandler {
                                            id: cfH
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: isForgetPending = false
                                        }
                                    }

                                    Rectangle {
                                        width: 54
                                        height: 24
                                        radius: 6
                                        color: ffH.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.35) : Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18)
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 80
                                            }
                                        }
                                        Widgets.StyledText {
                                            anchors.centerIn: parent
                                            text: "Forget"
                                            font.pixelSize: 10
                                            color: Config.Theme.error
                                        }
                                        HoverHandler {
                                            id: ffH
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: Services.Network.forget(modelData.ssid)
                                        }
                                    }
                                }
                            }
                        }

                        // password row
                        Item {
                            id: passRow
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                topMargin: 8
                            }
                            implicitHeight: 40
                            opacity: isExpanded ? 1 : 0
                            visible: opacity > 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            Rectangle {
                                anchors {
                                    fill: parent
                                    leftMargin: 10
                                    rightMargin: 10
                                }
                                height: 32
                                radius: 8
                                color: Qt.rgba(1, 1, 1, 0.06)
                                border.color: passInput.activeFocus ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55) : Qt.rgba(1, 1, 1, 0.12)
                                border.width: 1
                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 120
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: passInput.forceActiveFocus()
                                }
                                Widgets.StyledText {
                                    anchors {
                                        left: parent.left
                                        leftMargin: 10
                                        verticalCenter: parent.verticalCenter
                                    }
                                    text: "Password…"
                                    font.pixelSize: 12
                                    color: Qt.rgba(1, 1, 1, 0.22)
                                    visible: passInput.text === ""
                                }

                                TextInput {
                                    id: passInput
                                    focus: true
                                    activeFocusOnPress: true
                                    anchors {
                                        left: parent.left
                                        leftMargin: 10
                                        right: eyeBtn.left
                                        rightMargin: 6
                                        top: parent.top
                                        bottom: parent.bottom
                                    }
                                    verticalAlignment: TextInput.AlignVCenter
                                    color: Config.Theme.surfaceOn
                                    font.pixelSize: 12
                                    echoMode: _showPass ? TextInput.Normal : TextInput.Password
                                    selectionColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                                    clip: true
                                    Keys.onReturnPressed: {
                                        if (text.length > 0)
                                            Services.Network.connectWithPassword(modelData.ssid, text);
                                    }
                                }

                                Item {
                                    id: eyeBtn
                                    anchors {
                                        right: parent.right
                                        verticalCenter: parent.verticalCenter
                                    }
                                    width: 28
                                    height: 28
                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 6
                                        color: eyeH.hovered ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                                    }
                                    Widgets.MaterialIcon {
                                        anchors.centerIn: parent
                                        text: _showPass ? "visibility_off" : "visibility"
                                        font.pixelSize: 13
                                        color: _showPass ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.28)
                                    }
                                    HoverHandler {
                                        id: eyeH
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: _showPass = !_showPass
                                    }
                                }
                            }
                        }

                        onVisibleChanged: {
                            if (visible && isExpanded)
                                Qt.callLater(() => passInput.forceActiveFocus());
                        }
                    }

                    onIsExpandedChanged: {
                        if (isExpanded)
                            Qt.callLater(() => passInput.forceActiveFocus());
                        else
                            passInput.text = "";
                    }

                    HoverHandler {
                        id: rHov
                        enabled: !modelData.inUse
                    }
                }
            }
        }
    }
}
