import QtQuick

Rectangle {
    id: root

    // Generic state property (e.g., active, pending, selected)
    property bool active: false

    // Color properties (must be type 'color', not 'string')
    property color rectColor: Qt.rgba(1, 1, 1, 0.10)
    property color rectFallbackColor: "transparent"

    property color iconColor: Qt.rgba(1, 1, 1, 0.65)
    property color iconFallbackColor: Qt.rgba(1, 1, 1, 0.35)

    property string iconText: ""
    property int pixelSize: 14
    property int customRadius: 6

    signal clicked

    width: 24
    height: 24
    radius: customRadius
    anchors.centerIn: parent // Cleanly centers inside parent wrapper

    // Evaluates both internal hover and external active state
    color: (hover.hovered || root.active) ? rectColor : rectFallbackColor

    MaterialIcon {
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
