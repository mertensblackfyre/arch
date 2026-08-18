// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../widgets" as Widgets
import "../../config" as Config
import "../../services" as Services
import "../popup" as Pop

PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.bottom: true
    implicitWidth: 35
    color: "transparent"

    Rectangle {
        id: barBackground
        width: parent.width
        height: parent.height
        topLeftRadius: Config.Appearance.rounding.large
        bottomLeftRadius: Config.Appearance.rounding.large
        color: Config.Theme.background

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: activeWindowPill.top
            spacing: 10

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                topRightRadius: Config.Appearance.rounding.normal
                bottomRightRadius: Config.Appearance.rounding.normal
                Workspaces {}
            }

            Item { Layout.fillHeight: true }
        }

        Widgets.Pill {
            id: activeWindowPill
            anchors.centerIn: parent
            color: "transparent"
            topRightRadius: Config.Appearance.rounding.normal
            bottomRightRadius: Config.Appearance.rounding.normal

            ActiveWindow {}
        }

        ColumnLayout {
            anchors.top: activeWindowPill.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 10

            Item { Layout.fillHeight: true }

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                cornerRadius: Config.Appearance.rounding.normal
                Wifi {}
                Battery {}
            }

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                color: "transparent"
                cornerRadius: Config.Appearance.rounding.normal
                Clock {}
            }
        }
    }
}
