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
    color:Config.Theme.backgroundOn
    font.pointSize: Config.Appearance.font.size.normal - 2
    font.bold: true
    verticalAlignment:Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    rotation: 0
}
