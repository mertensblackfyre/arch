import Quickshell
import QtQuick
import "../themes"

PopupWindow {
    id: tooltipPopup

    // Required properties
    required property var targetWidget
    required property bool triggerTarget
    required property rect position
    required property int expandDirection

    // Optional properties
    property int showDelay: 800
    property int hideDelay: 200
    property color backgroundColor:ThemeManager.primary // add default color from theme
    property real backgroundRadius // add default rounding from theme
    property bool blockShow: false // NEW: override showing (ex. when a menu is open)

    // do not mess with these unless required
    default property alias data: contentContainer.data
    property bool isHovered

    anchor {
        item: targetWidget
        rect: position
        gravity: expandDirection
    }

    color: "transparent"
    visible: internal.actuallyVisible
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    QtObject {
        id: internal
        property bool actuallyVisible: tooltipPopup.isHovered ? true : false
    }

    Rectangle {
        id: content
        color: tooltipPopup.backgroundColor
        radius: tooltipPopup.backgroundRadius
        implicitWidth: contentContainer.implicitWidth
        implicitHeight: contentContainer.implicitHeight
        // animation magic
        scale: internal.actuallyVisible ? 1.0 : 0.8
        opacity: internal.actuallyVisible ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.25, 0.1, 0.25, 1.0]
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.BezierSpline
                easing.bezierCurve: [0.25, 0.1, 0.25, 1.0]
            }
        }

        Item {
            id: contentContainer
            anchors.centerIn: parent
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
