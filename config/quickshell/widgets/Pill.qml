// Pill.qml
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    default property alias content: contentColumn.data
    property int padding: 8
    property bool alignTop: false

    implicitWidth: parent.width - 8
    implicitHeight: contentColumn.implicitHeight + padding * 2
    radius: 15
    color: "#FF0800"

    Behavior on color {
        ColorAnimation {  }
    }

    ColumnLayout {
        id: contentColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.alignTop ? parent.top : undefined
        anchors.verticalCenter: root.alignTop ? undefined : parent.verticalCenter
        anchors.margins: root.padding
        spacing: 4
    }
}
