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
            if (!root.Quickshell.window) {
                console.warn("No window yet!");
                return;
            }
            const mapped = root.mapToItem(null, 0, 0);
            popup.anchorRect = Qt.rect(mapped.x, mapped.y, root.width, root.height);
            popup.shouldShow = !popup.shouldShow;
        }
    }
    NetworkPop {
        id: popup
        targetWidget: root
        shouldShow: root.networkPopup
        expandDirection: Edges.Right
    }
}
