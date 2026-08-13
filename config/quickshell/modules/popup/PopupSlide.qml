// modules/popup/PopupSlide.qml
import QtQuick

Item {
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

    NumberAnimation {
        id: slideIn
        target: parent.target
        property: "x"
        to: 0
        duration: 300
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: slideOut
        target: parent.target
        property: "x"
        to: -parent.target.width
        duration: 250
        easing.type: Easing.InCubic
    }
}
