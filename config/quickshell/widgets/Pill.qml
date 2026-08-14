// Pill.qml
import QtQuick
import QtQuick.Layouts
import "../config" as Config

Rectangle {
    id: root

    default property alias content: contentColumn.data

    property real contentSpacing: Config.Appearance.spacing.small
    property int padding: 8
    property bool alignTop: false

    property bool hoverAllowed: false
    property bool isHovered: hoverHandler.hovered

    property int cornerRadius: 0

    property int _width: parent.width
    property int _height: contentColumn.implicitHeight + Config.Appearance.padding.large * 2

    radius: cornerRadius

    implicitWidth: _width
    implicitHeight: _height

    color: {
        if (!hoverAllowed)
            return Config.Theme.surfaceContainer;

        return hoverHandler.hovered ? Config.Theme.primaryOn : Config.Theme.surfaceContainer;
    }

    Behavior on color {
        ColorAnimation {}
    }

    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: Qt.PointingHandCursor
    }

    ColumnLayout {
        id: contentColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.alignTop ? parent.top : undefined
        anchors.verticalCenter: root.alignTop ? undefined : parent.verticalCenter
        anchors.margins: root.padding
        spacing: root.contentSpacing
    }
}
