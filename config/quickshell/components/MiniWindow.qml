// Okay.qml
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Item {
    id: root

    property var parent_window
    property var positin_x
    property var positin_y
    property Item parentItem
    //LazyLoader {
    //   id: popupLoader

    PopupWindow {
        id: popup

        visible: true
        color: "red"

        anchor {
            window: root.parent_window
        }

        anchor.rect.x: root.positin_x
        anchor.rect.y: root.positin_y
    }
}
