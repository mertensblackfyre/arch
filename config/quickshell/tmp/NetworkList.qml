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
                    width: parent.width - 15
                    height: 40
                    radius: Config.Appearance.rounding.small

                                  border.width: 1
                            Behavior on color { ColorAnimation { duration: 130 } }
                            Behavior on border.color { ColorAnimation { duration: 130 } }

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

                            text: Services.Icons.getNetworkIcon(modelData.signal, modelData.secured)
                        }

                        Widgets.StyledText {
                            anchors.left: parent.left
                            font.pixelSize: Config.Appearance.font.size.normal + 2
                            font.bold: modelData.inUse

                            anchors.leftMargin: Config.Appearance.spacing.large
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.ssid
                            color:modelData.inUse?Config.Theme.primaryOn: Config.Theme.inverseOnSurface
                        }
                    }
                    HoverHandler {
                            id: rowHover
                            enabled: true
                            cursorShape: Qt.PointingHandCursor
                        }
                }
            }
        }
    }


}
