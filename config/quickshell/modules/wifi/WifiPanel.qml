// modules/wifi/WifiPanel.qml
import Quickshell
//import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import "../../widgets" as Widgets
import "../../config" as Config

PanelWindow {
    id: root

    property bool isOpen: false

    anchors.left: true
    anchors.top: true
    anchors.bottom: true

    implicitWidth: Services.PopupService.popupWidth
    margins.left: 48

    color: "transparent"
    exclusiveZone: -1  // don't push windows
    visible: isOpen
    aboveWindows: true
    Behavior on implicitWidth {
        Widgets.Anim{
            duration: Config.Appearance.anim.durations.small
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Config.Theme.surfaceContainer
        radius: 16

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            // Header
            RowLayout {
                Layout.fillWidth: true

                Widgets.StyledText {
                    text: "WiFi"
                    font.pixelSize: 16
                    font.bold: true
                    color: Config.Theme.primary
                    Layout.fillWidth: true
                }

                Widgets.MaterialIcon {
                    text: "close"
                    color: Config.Theme.primaryOn
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.isOpen = false
                    }
                }
            }

            // Network list
            NetworkList {
                Layout.fillWidth: true
                Layout.fillHeight: true
               }
        }
    }
}
