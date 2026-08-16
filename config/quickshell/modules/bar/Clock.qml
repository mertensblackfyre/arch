import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config

Widgets.StyledText {
    id: root

    property var now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    text: Qt.formatTime(root.now, "hh\nmm")
    font.pointSize: Config.Appearance.font.size.smaller - 1
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    rotation: 0
}
