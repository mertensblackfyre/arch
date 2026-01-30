// Okay.qml
import QtQuick
import Quickshell
import QtQuick.Effects

Item {
    id: name
    LazyLoader {
        id: popupLoader

        PopupWindow {
            id: popup
            visible: true
            color: "transparent"
            //    implicitWidth: root.bar.width
            //   implicitHeight: Math.max(popup.screen.height, parentItem.targetHeight)

            // window: root.bar
            // rect: Qt.rect(0, 0, root.bar.width, root.bar.height)
            //  edges: Edges.Bottom | Edges.Left
            // gravity: Edges.Bottom | Edges.Right
            // adjustment: PopupAdjustment.None
            anchor {}

            MouseArea {
                anchors.fill: parent

                onClicked: function (mouse) {
                    let localPos = mapToItem(parentItem, mouse.x, mouse.y);
                }
            }

            RectangularShadow {
                anchors.fill: parentItem
                // radius: backgroundLoader.item.radius ?? 8
                blur: 16
                spread: 2
                offset: Qt.vector2d(0, 4)
                color: Qt.rgba(0, 0, 0, 0.5)
            }

            Item {
                id: parentItem
                clip: true
            }

            Loader {
                id: backgroundLoader
                anchors.fill: parent
                //    sourceComponent: root.shownItem?.backgroundComponent ?? defaultBackground
            }
        }
    }
}
