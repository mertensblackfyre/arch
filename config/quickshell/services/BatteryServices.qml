pragma Singleton
import QtQuick
import Quickshell.Services.UPower

QtObject {

    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    property real percentage: UPower.displayDevice?.percentage ?? 1
    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    function formatTime(seconds) {
        var h = Math.floor(seconds / 3600);
        var m = Math.floor((seconds % 3600) / 60);
        var s = seconds % 60;

        // Format as HH:MM:SS
        return (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
    }

    function icons() {
        var whole = percentage * 100;
        var icon

        if (whole == 100) {
            icon += "battery_android_full";
            return icon;
        }

        if (chargeState == 4) {
            icon += "battery_android_pen";
            return icon;
        }
        if (isCharging) {
            icon += "battery_android_bolt";
            return icon;
        }
        if (whole < 100 && whole >= 90) {
            icon += "battery-6.svg";
        }
        if (whole < 90 && whole >= 70) {
            icon += "battery-5.svg";
        }

        if (whole < 70 && whole >= 50) {
            icon += "battery-4.svg";
        }

        if (whole < 50 && whole >= 30) {
            icon += "battery-3.svg";
        }

        if (whole < 30 && whole >= 20) {
            icon += "battery-2.svg";
        }

        if (whole < 20 && whole >= 10) {
            icon += "battery-1.svg";
        }

        if (whole < 10) {
            icon += "battery-warning.svg";
        }
        return icon;
    }
}
