// modules/wifi/NetworkList.qml
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../widgets" as Widgets
import "../../config" as Config

Item {
    id: root

    property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
    property var wifi: wifiDevice as WifiDevice

    implicitHeight: networkColumn.implicitHeight

    Component.onCompleted: {
        if (root.wifi) root.wifi.scannerEnabled = true
    }

    Column {
        id: networkColumn
        anchors.fill: parent
        spacing: 4
        RowLayout {
               Layout.fillWidth: true

               Widgets.StyledText {
                   text: "Networks"
                   font.pixelSize: Config.Appearance.font.size.large
                   color:Config.Theme.primary

                   Layout.fillWidth: true
               }

               Widgets.MaterialIcon {
                   text: "refresh"
                   color: Config.Theme.primary
                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           root.wifi.scannerEnabled = false
                           root.wifi.scannerEnabled = true
                       }
                   }
               }
           }
        Repeater {
            model: root.wifi?.networks?.values ?? []
            NetworkItem {
                required property var modelData
                width: networkColumn.width
                accessPoint: modelData
                isConnected: modelData.connected
            }
        }
    }

}
