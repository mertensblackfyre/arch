// modules/popup/PopupLayer.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../services" as Services
import "../wifi"

PanelWindow {
    id: root

    anchors.left: true
    anchors.top: true
    anchors.bottom: true
    margins.left: 48
    exclusiveZone: -1
    aboveWindows: true
    color: "transparent"

    visible: Services.ShellState.activePopup !== ""
    implicitWidth: 280

    // close on outside click
    MouseArea {
        anchors.fill: parent
        onClicked: Services.ShellState.close()
    }

    Rectangle {
        id: panel
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        width: 264
        height: content.implicitHeight + 24
        radius: 16
        color: "#271d1d"

        // stop outside click from propagating through
        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Loader {
            id: content
            anchors.fill: parent
            anchors.margins: 12
            sourceComponent: {
                switch (Services.ShellState.activePopup) {
                    case "wifi": return wifiPopup
                    default: return null
                }
            }
        }
    }

    PopupSlide {
        target: panel
        open: Services.ShellState.activePopup !== ""
    }

    Component { id: wifiPopup; NetworkList {} }
}
