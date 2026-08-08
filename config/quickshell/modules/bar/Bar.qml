// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../widgets" as Widgets
import "../../config" as Config


PanelWindow {
    id: root
    anchors.top: true
    anchors.left: true
    anchors.bottom: true
    implicitWidth: 40
    exclusiveZone: 40
    color: "transparent"

    Rectangle {
        id: barBackground
        width: parent.width
        height: parent.height
        topRightRadius: 55
        bottomRightRadius: 55

        color: Config.Theme.background
        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                color:Config.Theme.surfaceContainer
                Workspaces {}
            }

            Item { Layout.fillHeight: true }
            }

    }
}
