// modules/bar/Battery.qml
import QtQuick
import Quickshell.Services.UPower
import "../../widgets" as Widgets
import "../../config" as Config

Widgets.MaterialIcon {
    id: root

    property var battery: UPower.displayDevice
    property bool charging: battery?.state === UPowerDeviceState.Charging
    property int percent: Math.round((battery?.percentage ?? 0) * 100)

    text: {
        if (charging)
            return "battery_charging_full";
        if (percent >= 90)
            return "battery_full";
        if (percent >= 60)
            return "battery_5_bar";
        if (percent >= 40)
            return "battery_3_bar";
        if (percent >= 20)
            return "battery_2_bar";
        return "battery_1_bar";
    }

    color: {
        // if (charging)
        //   return Config.Theme.primary;
        if (percent <= 20)
            return Config.Theme.error;
    }
}
