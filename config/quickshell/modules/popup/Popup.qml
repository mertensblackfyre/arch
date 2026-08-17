import Quickshell
import QtQuick
import "../wifi"
import "../../services" as Services

PanelWindow {
    id: win
    anchors.left: true
    anchors.bottom: true
    anchors.top: true
    exclusiveZone: -1
    aboveWindows: true
    color: "transparent"
    implicitWidth: Services.ShellState.panelWidth + 50

    visible: Services.ShellState.visible || hideTimer.running
    margins.left: 35

    Timer {
        id: hideTimer
        interval: 200
        repeat: false
        onTriggered: Services.ShellState._hide()
    }

    PopupLayer {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        baseWidth: 300
        baseHeight: 100
        expandHeight: Services.ShellState.panelHeight
        expandWidth: Services.ShellState.panelWidth
        expand: Services.ShellState.visible
        radius: 16

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: hideTimer.stop()
            onExited: hideTimer.start()
        }

        Loader {
            anchors.fill: parent
            sourceComponent: {
                switch (Services.ShellState.active) {
                case "wifi":
                    return wifiComponent;
                default:
                    return null;
                }
            }
        }

        Component {
            id: wifiComponent
            NetworkList {}
        }
    }
}
