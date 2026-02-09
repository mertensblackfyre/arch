// Time.qml
pragma ComponentBehavior: Bound
import "../../themes"
import "../../components/"
import "../../services/"
import "../../configs/" as Config
import QtQuick

Column {
    id: root

    spacing: 1
    property color colour: ThemeManager.palette.m3primary

    StyledText {
        id: text

        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: StyledText.AlignHCenter
        text: TimeService.format("hh\nmm")
        color: root.colour
        font.pointSize: Config.Appearance.font.size.smaller
        font.bold: true
    }
}
