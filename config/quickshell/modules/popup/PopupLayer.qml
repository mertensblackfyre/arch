// modules/popup/PopupLayer.qml
import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config

Item {
    id: root
    property bool expand: false
    required property real expandWidth
    required property real expandHeight
    property real baseWidth: expandWidth - 100
    property real baseHeight: 200

    property alias bottomRightRadius: bg.bottomRightRadius
    property alias bottomLeftRadius: bg.bottomLeftRadius
    property alias topRightRadius: bg.topRightRadius
    property alias topLeftRadius: bg.topLeftRadius

    implicitHeight: expand ? expandHeight : baseHeight
    implicitWidth: expand ? expandWidth : baseWidth

    Rectangle {
        id: bg
        anchors.fill: parent
        color: Config.Theme.background
    }

    Behavior on implicitHeight {
        Widgets.Anim {}
    }

    Behavior on implicitWidth {
        Widgets.Anim {}
    }
}
