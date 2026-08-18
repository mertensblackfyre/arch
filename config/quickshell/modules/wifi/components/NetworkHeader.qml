// modules/wifi/components/NetworkHeader.qml
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    width: parent.width
    height: 40

    Widgets.StyledText {
        anchors {
            left: parent.left
            leftMargin: 2
            verticalCenter: parent.verticalCenter
        }
        text: "Wi-Fi"
        font.pixelSize: 15
        font.bold: true
        color: Config.Theme.surfaceOn
    }

    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: 8

        Rectangle {
            width: 32
            height: 32
            radius: 8
            color: wfPwrH.hovered ? (Services.Network.wifiEnabled ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18)) : Qt.rgba(1, 1, 1, 0.04)
            border.color: Services.Network.wifiEnabled ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.30)
            border.width: 1
            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: 120
                }
            }
            Widgets.StyledText {
                anchors.centerIn: parent
                text: "⏻"
                font.pixelSize: 14
                color: Services.Network.wifiEnabled ? (wfPwrH.hovered ? Config.Theme.error : Qt.rgba(1, 1, 1, 0.32)) : Config.Theme.primary
                Behavior on color {
                    ColorAnimation {
                        duration: 120
                    }
                }
            }
            HoverHandler {
                id: wfPwrH
                cursorShape: Qt.PointingHandCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Services.Network.setWifiEnabled(!Services.Network.wifiEnabled)
            }
        }

        // settings button
        Rectangle {
            width: 32
            height: 32
            radius: 8
            color: settH.hovered ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(1, 1, 1, 0.03)
            border.color: Qt.rgba(1, 1, 1, 0.10)
            border.width: 1
            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }
            Widgets.MaterialIcon {
                anchors.centerIn: parent
                text: "settings"
                font.pixelSize: 14
                color: settH.hovered ? Qt.rgba(1, 1, 1, 0.75) : Qt.rgba(1, 1, 1, 0.30)
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
            HoverHandler {
                id: settH
                cursorShape: Qt.PointingHandCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: Services.Network.openNmtui()
            }
        }

        // rescan button
        Rectangle {
            width: 32
            height: 32
            radius: 8
            color: rfH.hovered ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.15) : Qt.rgba(1, 1, 1, 0.05)
            border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.28)
            border.width: 1
            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
            Widgets.MaterialIcon {
                id: rfIcon
                anchors.centerIn: parent
                text: "refresh"
                font.pixelSize: 15
                color: Services.Network.scanning ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.4) : Services.Network.wifiEnabled ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.18)
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
                RotationAnimator {
                    target: rfIcon
                    from: 0
                    to: 360
                    duration: 900
                    loops: Animation.Infinite
                    running: Services.Network.scanning
                    easing.type: Easing.Linear
                }
            }
            HoverHandler {
                id: rfH
                cursorShape: Services.Network.wifiEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: if (!Services.Network.scanning && Services.Network.wifiEnabled)
                    Services.Network.scan(true)
            }
        }
    }
}
