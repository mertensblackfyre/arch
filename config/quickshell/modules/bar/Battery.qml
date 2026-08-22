// modules/bar/Battery.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import "../../widgets" as Widgets
import "../../services" as Services
import "../../config" as Config

Item {
    id: root

    property var battery: UPower.displayDevice
    property bool charging: battery?.state === UPowerDeviceState.Charging
    property int percent: Math.round((battery?.percentage ?? 0) * 100)

    width: icon.width - Config.Appearance.padding.large
    height: icon.height - Config.Appearance.padding.large

    Layout.alignment: Qt.AlignHCenter

    Widgets.IconButton {
        id: icon
        anchors.centerIn: parent

        iconText: {
            if (root.charging)
                return "battery_charging_full";
            if (root.percent >= 90)
                return "battery_full";
            if (root.percent >= 60)
                return "battery_5_bar";
            if (root.percent >= 40)
                return "battery_3_bar";
            if (root.percent >= 20)
                return "battery_2_bar";
            return "battery_1_bar";
        }

        pixelSize: Config.Appearance.font.size.extraLarge - 8
        customRadius: Config.Appearance.rounding.normal

        rectColor: "transparent"
        rectFallbackColor: rectColor

        iconColor: {
            if (root.charging)
                return Config.Theme.primaryOn;
            if (root.percent <= 20)
                return Config.Theme.error;
            return Config.Theme.primaryOn;
        }
        iconFallbackColor: iconColor

        onClicked: {
            Services.ShellState._show("battery", 500, 200);
        }
    }
}
