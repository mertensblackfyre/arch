// modules/bluetooth/components/BluetoothExpandArea.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root

    required property var device
    required property bool isPaired

    readonly property bool isRemovePending: Services.Bluetooth.removeMac === device.mac
    readonly property bool isPairingOpen: Services.Bluetooth.pairingMac === device.mac

    clip: true
    height: root.isRemovePending ? removeRow.implicitHeight + 16 : root.isPairingOpen ? pinRow.implicitHeight + 16 : 0

    Behavior on height {
        Widgets.Anim {}
    }

    // remove confirmation
    Item {
        id: removeRow
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 8
        }
        implicitHeight: 32
        opacity: root.isRemovePending ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            Widgets.Anim {}
        }

        Rectangle {
            anchors {
                fill: parent
                leftMargin: 8
                rightMargin: 8
            }
            radius: 8
            color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.06)
            border.color: Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.22)
            border.width: 1

            Row {
                anchors.centerIn: parent
                spacing: 12

                Widgets.StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Remove this device?"
                    font.pixelSize: 11
                    color: Qt.rgba(1, 1, 1, 0.5)
                }

                Rectangle {
                    width: 58
                    height: 24
                    radius: 6
                    color: cxH.hovered ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.04)
                    Behavior on color {
                        Widgets.ColorAnim {}
                    }
                    Widgets.StyledText {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.pixelSize: 10
                        color: Qt.rgba(1, 1, 1, 0.42)
                    }
                    HoverHandler {
                        id: cxH
                        cursorShape: Qt.PointingHandCursor
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Services.Bluetooth.removeMac = ""
                    }
                }

                Rectangle {
                    width: 64
                    height: 24
                    radius: 6
                    color: rxH.hovered ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.40) : Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18)
                    Behavior on color {
                        Widgets.ColorAnim {}
                    }
                    Widgets.StyledText {
                        anchors.centerIn: parent
                        text: "Remove"
                        font.pixelSize: 10
                        color: Config.Theme.error
                    }
                    HoverHandler {
                        id: rxH
                        cursorShape: Qt.PointingHandCursor
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Services.Bluetooth.remove(root.device.mac)
                    }
                }
            }
        }
    }

    // pin row
    Item {
        id: pinRow
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 8
        }
        implicitHeight: pinCol.implicitHeight
        opacity: root.isPairingOpen ? 1 : 0
        visible: opacity > 0
        Behavior on opacity {
            Widgets.Anim {}
        }

        Column {
            id: pinCol
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: 8
                rightMargin: 8
            }
            spacing: 6

            Widgets.StyledText {
                width: parent.width
                text: "Legacy PIN pairing — enter the PIN shown on your device"
                font.pixelSize: 10
                color: Qt.rgba(1, 1, 1, 0.30)
                wrapMode: Text.WordWrap
            }

            Row {
                width: parent.width
                spacing: 8

                Rectangle {
                    width: parent.width - pairConfBtn.width - parent.spacing
                    height: 32
                    radius: 8
                    color: Qt.rgba(1, 1, 1, 0.06)
                    border.color: pinInput.activeFocus ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55) : Qt.rgba(1, 1, 1, 0.12)
                    border.width: 1
                    Behavior on border.color {
                        Widgets.ColorAnim {}
                    }

                    Widgets.StyledText {
                        anchors {
                            left: parent.left
                            leftMargin: 10
                            verticalCenter: parent.verticalCenter
                        }
                        text: "PIN (optional)…"
                        font.pixelSize: 12
                        color: Qt.rgba(1, 1, 1, 0.22)
                        visible: pinInput.text === ""
                    }

                    TextInput {
                        id: pinInput
                        anchors {
                            fill: parent
                            leftMargin: 10
                            rightMargin: 10
                        }
                        verticalAlignment: TextInput.AlignVCenter
                        color: Config.Theme.surfaceOn
                        font.pixelSize: 12
                        font.family: Config.Appearance.font.family.mono
                        inputMethodHints: Qt.ImhDigitsOnly
                        maximumLength: 8
                        selectionColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                        clip: true
                        Keys.onReturnPressed: Services.Bluetooth.pair(root.device.mac, text)
                    }
                }

                Rectangle {
                    id: pairConfBtn
                    width: 64
                    height: 32
                    radius: 8
                    color: pcH.hovered ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.30) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.14)
                    border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.42)
                    border.width: 1
                    Behavior on color {
                        Widgets.ColorAnim {}
                    }

                    Widgets.StyledText {
                        anchors.centerIn: parent
                        text: "Pair"
                        font.pixelSize: 11
                        color: Config.Theme.primary
                    }

                    HoverHandler {
                        id: pcH
                        cursorShape: Qt.PointingHandCursor
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Services.Bluetooth.pair(root.device.mac, pinInput.text)
                    }
                }
            }
        }
    }

    onIsPairingOpenChanged: if (!isPairingOpen)
        pinInput.text = ""
}
