// BatteryIndicator.qml
import QtQuick
import Quickshell
import "../../services"
import "../../components/"
import "../../utils/"

Item {
    id: battery_item
    implicitWidth: 24
    implicitHeight: 24

    property var parent_window

    MaterialIcon {
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -font.pointSize / 10

        text: BatteryServices.icons()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
