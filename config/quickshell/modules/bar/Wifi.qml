// modules/bar/Wifi.qml
import QtQuick
import Quickshell.Networking
import "../../widgets" as Widgets
import "../../services" as Services

Widgets.MaterialIcon {
    id: root

    property var wifiDevice: Networking.devices.values.find(d => d.type === NetworkDeviceType.Wifi)
    property var wifi: wifiDevice as WifiDevice
    property int strength: wifi?.activeAccessPoint?.strength ?? 0
    property bool secured: wifi?.activeAccessPoint?.secured ?? false
    property bool connected: wifiDevice?.connected ?? false

    text: Services.Icons.getNetworkIcon(strength, secured)
    color: connected ? "white" : "gray"
}
