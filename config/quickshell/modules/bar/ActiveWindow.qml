// ActiveWindow.qml

import Quickshell.Hyprland
import QtQuick

import "../../components"
import "../../themes"
import "../../configs"
import "../../services"

Item {
    id: root
    implicitWidth: parent.width
    implicitHeight: 120

    property color colour: ThemeManager.palette.m3primary

    property string appClass: "DESKTOP"

    MaterialIcon {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        animate: true
        // text: Icon.getAppCategoryIcon(Hyprland.activeToplevel?.lastIpcObject.class, "desktop_windows")
        color: root.colour
    }

    Behavior on implicitHeight {
        Anim {
            duration: Appearance.anim.durations.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }

    TextMetrics {
        id: textMetrics
        font.pixelSize: 14
        font.bold: true
        text: HyprlandService.getTruncatedTitle(25) ?? qsTr("Desktop")
    }

    StyledText {
        anchors.centerIn: parent

        text: HyprlandService.getTruncatedTitle(25) ?? qsTr("Desktop")
        color: ThemeManager.palette.m3primary
        font.pixelSize: 14
        font.bold: true
        rotation: 270
        elide: Text.ElideRight
        width: textMetrics.width + 10
        height: textMetrics.height

        Behavior on opacity {
            Anim {}
        }
    }
}
