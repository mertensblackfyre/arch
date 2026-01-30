// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.bottom: true
    implicitWidth: 35
    color: "#000000"

    Item {
        anchors.fill: parent
        WorkSpaces {
            id: workspaces
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ColumnLayout {
            spacing: 10
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 12
            BatteryIndicator {
                parent_window:root
            }

            Time {}
        }
    }
}
