// Pill.qml
import QtQuick

Rectangle {
    id: root
    // This captures anything you put between { }
    default property alias content: contentContainer.data

    property int verticalPadding: 15
    property real opacityLevel: 0.3

    // Pill width is slightly smaller than the Bar
    width: parent.width - 8
    height: contentContainer.childrenRect.height + (verticalPadding * 2)
    anchors.horizontalCenter: parent.horizontalCenter

    radius: 15

    //   color: ThemeManager.palette.m3surfaceDim
    Item {
        id: contentContainer
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        onChildrenChanged: {
            for (var i = 0; i < children.length; i++) {
                children[i].anchors.horizontalCenter = contentContainer.horizontalCenter;
            }
        }
    }
}
