pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: root
    required property var modelData
    required property int index

    property bool isForgetPending: false
    property bool isExpanded: Services.Network.expandSsid === modelData.ssid
    property bool isConnecting: Services.Network.connectingTo === modelData.ssid
    property bool _showPass: false
    property var networkColumn

    width: networkColumn.width
    height: baseRow.height + expandArea.height

    Rectangle {
        anchors.fill: parent
        radius: Config.Appearance.rounding.small
        border.width: 1
        color: root.modelData.inUse ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07) : rHov.hovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
        border.color: root.modelData.inUse ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18) : Qt.rgba(1, 1, 1, 0.06)
        Behavior on color {
            Widgets.ColorAnim {}
        }
        Behavior on border.color {
            Widgets.ColorAnim {}
        }
    }

    NetworkBaseRow {
        id: baseRow
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 48

        modelData: root.modelData
        passInput: expandArea.inputItem
    }

    NetworkExpandArea {
        id: expandArea
        modelData: root.modelData
        baseRow: baseRow
    }

    onIsExpandedChanged: {
        if (isExpanded)
            Qt.callLater(() => expandArea.inputItem.forceActiveFocus());
        else
            expandArea.inputItem.text = "";
    }

    HoverHandler {
        id: rHov
        enabled: !root.modelData.inUse
    }
}
