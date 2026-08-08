pragma ComponentBehavior: Bound
// PopupContainer.qml - Reusable popup component
import QtQuick
import Quickshell
import QtQuick.Effects

Item {
    id: root

    // Properties for customization
    property bool isOpen: false
    property Item anchor: null
    property Component contentComponent: null
    property real shadowBlur: 16
    property real shadowSpread: 2
    property color shadowColor: Qt.rgba(0, 0, 0, 0.5)
    property color backgroundColor: "#2a2a2a"
    property real cornerRadius: 8
    property real horizontalOffset: 0
    property real verticalOffset: 8

    // Signals
    signal closeRequested()

    LazyLoader {
        id: popupLoader
        active: root.isOpen

        PopupWindow {
            id: popup
            visible: root.isOpen
            color: "transparent"

            anchor {
                window: Quickshell.window
                rect: root.anchor ? Qt.rect(
                    root.anchor.mapToItem(null, 0, 0).x,
                    root.anchor.mapToItem(null, 0, 0).y,
                    root.anchor.width,
                    root.anchor.height
                ) : Qt.rect(0, 0, 0, 0)
                edges: Edges.Bottom | Edges.Left
                gravity: Edges.Bottom | Edges.Right
            }

            // Click outside to close
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.isOpen = false
                    root.closeRequested()
                }
            }

            // Shadow effect
            RectangularShadow {
                anchors.fill: contentContainer
                radius: root.cornerRadius
                blur: root.shadowBlur
                spread: root.shadowSpread
                offset: Qt.vector2d(0, 4)
                color: root.shadowColor
            }

            // Content container
            Item {
                id: contentContainer
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: root.verticalOffset
                    leftMargin: root.horizontalOffset
                }
                width: contentLoader.width
                height: contentLoader.height

                // Background rectangle
                Rectangle {
                    anchors.fill: parent
                    color: root.backgroundColor
                    radius: root.cornerRadius
                }

                // Content loader
                Loader {
                    id: contentLoader
                    sourceComponent: root.contentComponent
                    onLoaded: {
                        contentContainer.width = contentLoader.width
                        contentContainer.height = contentLoader.height
                    }
                }
            }
        }
    }
}
