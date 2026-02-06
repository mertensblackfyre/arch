import QtQuick
import QtQuick.Layouts
import "../components"
import "../configs/" as Config

import "../themes/" 

Rectangle {
    id: root

    default property alias content: contentColumn.data
    property real contentSpacing: Config.Appearance.spacing.larger
    property bool alignTop: false

    implicitHeight: contentColumn.implicitHeight + Config.Appearance.padding.large * 2
    implicitWidth: root.parent.width - 10

    radius: Config.Appearance.rounding.normal
    color: ThemeManager.layer(ThemeManager.palette.m3surfaceContainer, 2)

    Behavior on color {
        CAnimation {}
    }

    ColumnLayout {
        id: contentColumn
        anchors.top: root.alignTop ? parent.top : undefined
        anchors.verticalCenter: root.alignTop ? undefined : parent.verticalCenter
        anchors.margins: Config.Appearance.padding.large

        anchors.horizontalCenter: root.alignTop ? undefined : parent.horizontalCenter
        spacing: root.contentSpacing
    }
}
