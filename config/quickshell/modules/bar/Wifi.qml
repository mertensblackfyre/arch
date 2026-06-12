pragma ComponentBehavior: Bound

import QtQuick
import "../../components/"
import "../../services/"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    readonly property bool isHovered: mouseArea.containsMouse

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
            networkPop.togglePopup();
        }
    }

    NetworkPop {
        id: networkPop
        anchorItem: root
        networkService: NetworkService
    }
}
