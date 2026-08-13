// Pill.qml
import QtQuick
import QtQuick.Layouts
import "../config" as Config

Rectangle {
    id: root
    default property alias content: contentColumn.data
    property real contentSpacing: Config.Appearance.spacing.small
    property int padding: 8
    property bool alignTop: false

    implicitWidth: parent.width - 10
    implicitHeight: contentColumn.implicitHeight + Config.Appearance.padding.large * 2
    radius: Config.Appearance.rounding.normal

    Behavior on color {
        ColorAnimation {}
    }

    ColumnLayout {
        id: contentColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.alignTop ? parent.top : undefined
        anchors.verticalCenter: root.alignTop ? undefined : parent.verticalCenter
        anchors.margins: root.padding
        spacing: root.contentSpacing
    }
}
