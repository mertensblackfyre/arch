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
            anchors.fill: parent
            spacing: 10

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                topRightRadius: Config.Appearance.rounding.normal
                bottomRightRadius: Config.Appearance.rounding.normal
                Workspaces {}
            }

            Item {
                Layout.fillHeight: true
            }

            Widgets.Pill {
                Layout.alignment: Qt.AlignHCenter
                color: "transparent"

                topRightRadius: Config.Appearance.rounding.normal
                bottomRightRadius: Config.Appearance.rounding.normal
                ActiveWindow {}
            }

            Item {
                Layout.fillHeight: true
            }

            Widgets.Pill {
                implicitHeight: _height - Config.Appearance.padding.normal
                color: "transparent"
                //color: Config.Theme.background
                topRightRadius: Config.Appearance.rounding.normal
                bottomRightRadius: Config.Appearance.rounding.normal
                contentSpacing: 5
                Widgets.Pill {
                    hoverAllowed: true
                    cornerRadius: Config.Appearance.rounding.normal

                    Battery {}
                    Wifi {}

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Services.ShellState._show("wifi", 420, 220);
                        }
                    }
                }

                Widgets.Pill {
                    hoverAllowed: true
                    implicitWidth: root.width - 8
                    cornerRadius: Config.Appearance.rounding.normal
                    Clock {}
                }
            }
        }
    }
}
