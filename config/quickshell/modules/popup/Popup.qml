// modules/popup/Popup.qml
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
    visible: Services.ShellState.visible
    margins.left: 35

    PopupLayer {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        //anchors.leftMargin: 35
        // anchors.bottomMargin: 10
        baseWidth: 300
        baseHeight: 100
        expandHeight: Services.ShellState.panelHeight
        expandWidth: Services.ShellState.panelWidth
        expand: Services.ShellState.visible
        topRightRadius: 30

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onExited: Services.ShellState._hide()
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
