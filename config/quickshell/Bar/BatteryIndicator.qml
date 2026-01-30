// BatteryIndicator.qml
import QtQuick
import Quickshell
import "../services"
import "../components/"

Item {
    id: battery_item
    implicitWidth: 20
    implicitHeight: 20

    property var parent_window

    Image {
        id: indicator
        source: Qt.resolvedUrl(Services.icons())
        fillMode: Image.PreserveAspectFit
        width: 24
        height: 24
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    MiniWindow {
        targetWidget: indicator
        triggerTarget: true
        position: Qt.rect(30, battery_item.height - 5, 0, 0)
        expandDirection: Edges.Right

        isHovered: mouseArea.containsMouse
        backgroundColor: "#111111"
        backgroundRadius: 10

        Text {
            color: "#ccc9dc"
            text: Services.percentage * 100 + " %"
            font.weight: 500
            width: 100
            height: 30
            padding: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
