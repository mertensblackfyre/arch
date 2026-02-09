// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../components"
import "../../themes"

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.bottom: true
    implicitWidth: 40 // Keeping your width exactly as requested

    mask: null
    color: "transparent"

    Rectangle {
        id: barBackground
        anchors.fill: parent
        color: ThemeManager.palette.m3background

        topRightRadius: 55
        bottomRightRadius: 55

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            PillContainer {
                id: a
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                WorkSpaces {}
            }

            Item {
                Layout.fillHeight: true
            }

            PillContainer {
                id: b
                Layout.alignment: Qt.AlignHCenter
                ActiveWindow {
                    bar: barBackground
                }
            }

            Item {
                Layout.fillHeight: true
            }

            PillContainer {
                id: c
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                BatteryIndicator {
                    parent_window: root
                }
                Time {}
            }
        }
    }
}
