import QtQuick
import "../config" as Config

Rectangle {
    id: root

    property alias iconItem: iconElement

    property bool active: false

    property color rectColor: Qt.rgba(1, 1, 1, 0.10)
    property color rectFallbackColor: "transparent"

    property color iconColor: Qt.rgba(1, 1, 1, 0.65)
    property color iconFallbackColor: Qt.rgba(1, 1, 1, 0.35)

    property color borderColor: "transparent"

    property string iconText: ""
    property int pixelSize: 14
    property int customRadius: 6

    signal clicked

    implicitWidth: iconElement.width + Config.Appearance.padding.large
    implicitHeight: iconElement.height + Config.Appearance.padding.large

    radius: customRadius
    anchors.centerIn: parent
    border.color: borderColor
    color: (hover.hovered || root.active) ? rectColor : rectFallbackColor

    MaterialIcon {
        id: iconElement
        anchors.centerIn: parent
        text: root.iconText
        color: (hover.hovered || root.active) ? root.iconColor : root.iconFallbackColor
        font.pixelSize: root.pixelSize
        Behavior on color {
            ColorAnim {}
        }
    }

    HoverHandler {
        id: hover
        cursorShape: Qt.PointingHandCursor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
