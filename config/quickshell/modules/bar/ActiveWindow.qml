pragma ComponentBehavior: Bound

import QtQuick

import "../../components"
import "../../themes"
import "../../configs"
import "../../services"
import "../../utils"

Item {
    id: root

    readonly property int vPadding: Appearance.padding.large
    property color colour: ThemeManager.palette.m3primary
    property Title current: text1
    required property var bar

    readonly property int maxHeight: {
        let used = 0;

        for (let i = 0; i < bar.children.length; i++) {
            const c = bar.children[i];
            if (c === this)
                continue;
            if (c.Layout && c.Layout.fillHeight)
                continue;

            used += (c.nonAnimHeight ?? c.height);
        }

        return bar.height - used - 20 * (15 - 1) - vPadding * 2;
    }

    clip: true
    implicitWidth: Math.max(icon.implicitWidth, current.implicitHeight)
    implicitHeight: icon.implicitHeight + current.implicitWidth + current.anchors.topMargin

    MaterialIcon {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        animate: true
        text: Icons.getAppCategoryIcon(HyprlandService.activeToplevel?.lastIpcObject.class, "desktop_windows")
        color: root.colour
    }

    Title {
        id: text1
    }
    Title {
        id: text2
    }
    TextMetrics {
        id: metrics
        text: HyprlandService.activeToplevel?.title ?? qsTr("Desktop")
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        elide: Qt.ElideRight
        elideWidth: -root.maxHeight - icon.height

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
        onElideWidthChanged: root.current.text = elidedText
    }

    Behavior on implicitHeight {
        Anim {
            duration: Appearance.anim.durations.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }
    component Title: StyledText {
        id: text

        anchors.horizontalCenter: icon.horizontalCenter
        anchors.top: icon.bottom
        anchors.topMargin: Appearance.spacing.small

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: root.current === this ? 1 : 0
        font.bold: true

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
            Anim {}
        }
    }
}
