// modules/popup/PopupSlide.qml
import QtQuick
import "../../widgets" as Widgets

Item {
    id:root
    property var target
    property bool open: false

    onOpenChanged: {
        if (open) {
            target.x = -target.width
            slideIn.start()
        } else {
            slideOut.start()
        }
    }

    Widgets.Anim{
        id: slideIn
        target: root.target
        property: "x"
        to: 0
    }

    Widgets.Anim {
        id: slideOut
        target: root.target
        property: "x"
        to: -root.target.width
    }
}
