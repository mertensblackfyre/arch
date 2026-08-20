// modules/bar/Bluetooth.qml
import QtQuick
import QtQuick.Layouts
import "../../widgets" as Widgets
import "../../services" as Services
import "../../config" as Config

Item {
    id: root

    property bool isBluetoothOn: true
    property bool isConnected: false

    width: icon.width - Config.Appearance.padding.large
    height: icon.height - Config.Appearance.padding.large

    Layout.alignment: Qt.AlignHCenter

    Widgets.IconButton {
        id: icon

        anchors.centerIn: parent

        iconText: {
            if (!root.isBluetoothOn)
                return "bluetooth_disabled";
            if (root.isConnected)
                return "bluetooth_connected";
            return "bluetooth";
        }

        pixelSize: Config.Appearance.font.size.extraLarge - 8
        customRadius: Config.Appearance.rounding.normal

        rectColor: root.isBluetoothOn ? Config.Theme.surfaceLayer(Config.Theme.primary, 1) : Config.Theme.surfaceLayer(Config.Theme.background, 0)
        rectFallbackColor: rectColor

        iconColor: root.isBluetoothOn ? Config.Theme.primaryOn : Config.Theme.backgroundOn
        iconFallbackColor: iconColor

        onClicked: {
            Services.ShellState._show("bt", 450, 520);
        }
    }
}
