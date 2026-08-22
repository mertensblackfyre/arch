pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland
import "../../config" as Config
import "../../widgets" as Widgets
import "../../services" as Services

Item {
    id: root

    property Title current: text1

    property var activeToplevel: {
        const toplevels = Hyprland.focusedWorkspace?.toplevels?.values;
        if (!toplevels || toplevels.length === 0)
            return null;
        return toplevels.find(t => t.activated) ?? null;
    }

    function getTruncatedTitle(maxLength) {
        if (!activeToplevel?.title)
            return "Desktop";
        const title = activeToplevel.title.trim();
        return title.length > maxLength ? title.substring(0, maxLength) + "..." : title;
    }

    clip: true
    implicitWidth: Math.max(text1.implicitHeight, text2.implicitHeight)
    implicitHeight: icon.implicitHeight + current.implicitWidth + current.anchors.topMargin

    Title {
        id: text1
    }
    Title {
        id: text2
    }

    Widgets.MaterialIcon {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        animate: true

        color: Config.Theme.backgroundOn
        text: Services.Icons.getAppCategoryIcon(Services.Hyprland.activeToplevel?.lastIpcObject.class, "desktop_windows")
    }

    TextMetrics {
        id: metrics
        text: root.getTruncatedTitle(20) ?? "Desktop"
        font.pixelSize: Config.Appearance.font.size.larger
        font.family: Config.Appearance.font.family.mono

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = text;
            root.current = next;
        }
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            text1.text = metrics.text;
            root.current = text1;
        });
    }

    Behavior on implicitHeight {
        Widgets.Anim {}
    }

    component Title: Widgets.StyledText {
        id: text
        anchors.horizontalCenter: icon.horizontalCenter
        anchors.top: icon.bottom
        color: Config.Theme.backgroundOn
        anchors.topMargin: Config.Appearance.spacing.small
        font.pixelSize: metrics.font.pointSize
        font.family: metrics.font.family
        font.bold: true
        opacity: root.current === this ? 1 : 0
        transform: [
            Translate {
                x: -text.implicitWidth + text.implicitHeight
            },
            Rotation {
                angle: 270
                origin.x: text.implicitHeight / 2
                origin.y: text.implicitHeight / 2
            }
        ]
        width: implicitHeight
        height: implicitWidth

        Behavior on opacity {
            Widgets.Anim {}
        }
    }
}
