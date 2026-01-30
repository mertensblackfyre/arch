// WorkSpaces.qml
import Quickshell.Hyprland
import QtQuick
import "../themes"

Column {
    id: root
    anchors.margins: 12
    spacing: 6
    Repeater {
        model: Hyprland.workspaces.values
        Text {
            property var ws: modelData
            property bool isActive: Hyprland.focusedWorkspace?.id === ws.id
            function toJapanese(num) {
                const kanji = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];
                return kanji[num - 1] || num.toString();
            }
            text: toJapanese(ws.id)
            color: isActive ? ThemeManager.secondary : ThemeManager.tertiary
            font {
                pixelSize: 15
                bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + ws.id)
            }
        }
    }
}
