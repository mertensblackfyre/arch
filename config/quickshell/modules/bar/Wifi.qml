pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../../components/"
import "../../services/"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    readonly property bool isHovered: mouseArea.containsMouse

    property var barWindow
    property bool networkPopup: false

    MaterialIcon {
        id: icc
        anchors.horizontalCenter: parent.horizontalCenter
        animate: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -font.pointSize / 10
        text: NetworkService.materialSymbol
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -4
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            root.networkPopup = !root.networkPopup;
            console.log("Popup is now:", root.networkPopup);
        }
    }
    NetworkPop {
        targetWidget: root
        shouldShow: root.networkPopup
        position: Qt.rect(0, 0, root.width, root.height)
        expandDirection: Edges.Right
    }
}
