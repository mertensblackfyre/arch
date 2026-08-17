// modules/wifi/NetworkList.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../config" as Config
import "../../widgets" as Widgets
import "../../services" as Services

Item {
    id: root
    anchors.fill: parent

    component ScanRings: Item {
        id: ringsRoot
        property string centerGlyph: "󰤨"
        property int glyphSize: 18

        Repeater {
            model: 4
            delegate: Rectangle {
                required property int index
                anchors.centerIn: parent

                width: ringsRoot.width
                height: ringsRoot.height
                radius: ringsRoot.width / 2

                color: "transparent"
                border.color: Config.Theme.tertiary
                border.width: 1.5

                SequentialAnimation {
                    running: Services.Network.scanning
                    loops: Animation.Infinite
                    PauseAnimation {
                        duration: index * 150
                    }
                    ParallelAnimation {
                        Widgets.Anim {}
                        Widgets.Anim {}
                    }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: ringsRoot.centerGlyph
            font.pixelSize: ringsRoot.glyphSize
            color: Config.Theme.inversePrimary

            SequentialAnimation on opacity {
                running: Services.Network.scanning
                loops: Animation.Infinite
                Widgets.Anim {}
            }
        }
    }

    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: contentColumn.implicitHeight + Config.Appearance.rounding.large
        boundsBehavior: Flickable.StopAtBounds
        Column {
            id: contentColumn
            anchors.fill: parent
            spacing: 8

            anchors.margins: Config.Appearance.rounding.normal

            Item {
                width: parent.width
                height: 160
                visible: Services.Network.scanning && Services.Network.networks.length === 0

                ScanRings {
                    anchors.centerIn: parent
                    width: 96
                    height: 96
                }
            }

            Repeater {
                model: Services.Network.networks
                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 20
                    height: 40
                    color: Config.Theme.backgroundOn
                    radius: Config.Appearance.rounding.small

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: Config.Appearance.padding.large
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        spacing: Config.Appearance.spacing.large
                        Widgets.MaterialIcon {
                            anchors.verticalCenter: parent.verticalCenter

                            width: Config.Appearance.padding.larger
                            height: Config.Appearance.padding.larger
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.left: parent.left

                            text: Services.Icons.getNetworkIcon(modelData.signal, "1")
                        }

                        Widgets.StyledText {
                            anchors.left: parent.left

                            anchors.leftMargin: Config.Appearance.padding.large
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.ssid
                            color: Config.Theme.inverseOnSurface
                        }
                    }
                }
            }
        }
    }
}
