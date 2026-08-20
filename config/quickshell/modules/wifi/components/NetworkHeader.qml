// modules/wifi/components/NetworkHeader.qml
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    width: parent.width
    height: 25


    Widgets.StyledText {
        anchors {
            left: parent.left
            leftMargin: 2
            verticalCenter: parent.verticalCenter
        }

        text: "Wi-Fi"
        font.pixelSize: Config.Appearance.font.size.large
        font.bold: true
        color: Config.Theme.surfaceOn
    }

    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        spacing: Config.Appearance.spacing.small

        Item {
            width: 32
            height: 32

            Widgets.IconButton {
                readonly property bool isWifiOn: Services.Network.wifiEnabled

                iconText: "⏻"
                pixelSize: Config.Appearance.font.size.larger
                customRadius: Config.Appearance.rounding.small - 4

                iconColor: isWifiOn ? Config.Theme.error : Config.Theme.primary
                iconFallbackColor: isWifiOn ? Qt.rgba(1, 1, 1, 0.32) : Config.Theme.primary

                rectColor: isWifiOn ? Qt.rgba(Config.Theme.error.r, Config.Theme.error.g, Config.Theme.error.b, 0.18) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.04)

                borderColor: isWifiOn ? Qt.rgba(1, 1, 1, 0.10) : Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.30)

                onClicked: Services.Network.setWifiEnabled(!isWifiOn)
            }
        }

        Item {
            width: 32
            height: 32

            Widgets.IconButton {
                iconText: "settings"

                pixelSize: Config.Appearance.font.size.larger
                customRadius: Config.Appearance.rounding.small - 4

                iconColor: Qt.rgba(1, 1, 1, 0.75)
                iconFallbackColor: Qt.rgba(1, 1, 1, 0.30)

                rectColor: Qt.rgba(1, 1, 1, 0.09)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.03)

                borderColor: Qt.rgba(1, 1, 1, 0.10)

                onClicked: Services.Network.openNmtui()
            }
        }

        Item {
            width: 32
            height: 32

            Widgets.IconButton {
                id: refreshBtn

                readonly property bool isWifiOn: Services.Network.wifiEnabled
                readonly property bool isScanning: Services.Network.scanning

                iconText: "refresh"

                pixelSize: Config.Appearance.font.size.larger
                customRadius: Config.Appearance.rounding.small - 4

                iconColor: isScanning ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.4) : (isWifiOn ? Config.Theme.primary : Qt.rgba(1, 1, 1, 0.18))
                iconFallbackColor: iconColor

                rectColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.15)
                rectFallbackColor: Qt.rgba(1, 1, 1, 0.05)

                borderColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.28)

                onClicked: {
                    if (!isScanning && isWifiOn) {
                        Services.Network.scan(true);
                    }
                }

                RotationAnimator {
                    target: refreshBtn.iconItem
                    from: 0
                    to: 360
                    duration: 900
                    loops: Animation.Infinite
                    running: refreshBtn.isScanning
                    easing.type: Easing.Linear
                }
            }
        }
    }
}
