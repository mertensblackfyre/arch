// modules/bar/Wifi.qml
import QtQuick
import Quickshell.Networking
import "../../widgets" as Widgets
import "../../services" as Services
import "../wifi" as Wifi

Item {
    id: root

    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var wifi: wifiDevice as WifiDevice
    property int strength: wifi?.activeAccessPoint?.strength ?? 0
    property bool secured: wifi?.activeAccessPoint?.secured ?? false
    property bool connected: wifiDevice?.connected ?? false

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Widgets.MaterialIcon {
        id: icon
        text: Services.Icons.getNetworkIcon(root.strength, root.secured)
        //color: root.connected ? "white" : "gray"
    }
}
