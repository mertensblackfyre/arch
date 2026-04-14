pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

PopupWindow {
    id: root

    // Required properties that the parent must provide
    required property var targetWidget          // The item that triggered this popup
    required property rect anchorRect           // Widget's geometry in window coordinates
    required property int expandDirection       // Which side to pop out from

    // Simple visibility control
    property bool shouldShow: false

    // Show window when shouldShow is true OR while animating out
    visible: shouldShow || popupBox.opacity > 0

    // Transparent window background
    color: "transparent"

    // Anchor the popup relative to the target widget's window
    anchor {
        item: root.targetWidget
        rect: root.anchorRect
        gravity: root.expandDirection
    }

    // The actual visible content
    Rectangle {
        id: popupBox
        anchors.centerIn: parent

        width: 300
        height: 200
        radius: 16
        color: "#2d2d2d"
        border.color: "#555555"
        border.width: 1

        // Simple fade + scale animation
        opacity: root.shouldShow ? 1 : 0
        scale: root.shouldShow ? 1 : 0.9

        Behavior on opacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
            }
        }

        // Centered text
        Text {
            anchors.centerIn: parent
            text: "I'm a popup!"
            color: "white"
            font.pixelSize: 18
        }

        // Clicking outside closes it (optional)
        MouseArea {
            anchors.fill: parent
            z: -1  // Behind the box, catches clicks on empty window area
            onClicked: root.shouldShow = false
        }
    }
}
