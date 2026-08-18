// Workspaces.qml
import Quickshell.Hyprland
import QtQuick
import "../../config" as Config
import "../../widgets" as Widgets

Column {
    id: root
    spacing: 5

    Repeater {
        model: {
            let ws = [...Hyprland.workspaces.values];
            return ws.sort((a, b) => a.id - b.id);
        }

        Text {
            property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id
            property bool isHovered: hoverHandler.hovered

            function toJapanese(num) {
                const kanji = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];
                return kanji[num - 1] || num.toString();
            }

            text: toJapanese(modelData.id)
            color: isActive ? Config.Theme.primary : isHovered ? Config.Theme.secondary : Config.Theme.inverseOnSurface
            font.pixelSize: 15
            font.bold: true

            Behavior on color {
                Widgets.ColorAnim {}
            }

            HoverHandler {
                id: hoverHandler
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
            }
        }
    }
}
