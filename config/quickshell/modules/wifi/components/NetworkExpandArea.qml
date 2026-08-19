pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root
    required property var modelData

    property var baseRow
    property bool isForgetPending: false
    property bool isExpanded: Services.Network.expandSsid === root.modelData.ssid
    property bool isConnecting: Services.Network.connectingTo === root.modelData.ssid
    property bool _showPass: false
    property alias inputItem: passInput

    anchors {
        top: baseRow.bottom
        left: parent.left
        right: parent.right
    }
    clip: true

    height: root.isForgetPending ? forgetRow.implicitHeight + 16 : (root.isExpanded ? passRow.implicitHeight + 16 : 0)

    Behavior on height {
        Widgets.Anim {}
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
        opacity: root.isForgetPending ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {

            Widgets.Anim {}
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
                        Widgets.ColorAnim {}
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
                        onClicked: root.isForgetPending = false
                    }
                }

                Rectangle {
                    width: 54
                    height: 24
                    radius: 6
                    color: ffH.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.35) : Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18)
                    Behavior on color {
                        Widgets.ColorAnim {}
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
                        onClicked: Services.Network.forget(root.modelData.ssid)
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
        opacity: root.isExpanded && !root.isForgetPending ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {

            Widgets.Anim {}
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

                Widgets.ColorAnim {}
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
                echoMode: root._showPass ? TextInput.Normal : TextInput.Password
                selectionColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                clip: true
                Keys.onReturnPressed: {
                    if (text.length > 0)
                        Services.Network.connectWithPassword(root.modelData.ssid, text);
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

                Widgets.IconButton {
                    active: root._showPass

                    iconText: root._showPass ? "visibility_off" : "visibility"

                    iconColor: Config.Theme.primary
                    iconFallbackColor: Qt.rgba(1, 1, 1, 0.28)

                    rectColor: Qt.rgba(1, 1, 1, 0.08)
                    rectFallbackColor: "transparent"

                    pixelSize: 13
                    customRadius: 6

                    onClicked: root._showPass = !root._showPass
                }
            }
        }
    }

    onIsExpandedChanged: {
        if (isExpanded && !isForgetPending)
            Qt.callLater(() => passInput.forceActiveFocus());
    }
}
