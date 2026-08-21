pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "../../../widgets" as Widgets
import "../../../config" as Config

Item {
    id: root
    Column {
        anchors.fill: parent
        anchors.margins: Config.Appearance.padding.normal
        spacing: Config.Appearance.spacing.normal

        Behavior on opacity {}

        Item {
            id: search
            anchors {
                left: parent.left
                right: parent.right
            }
            implicitHeight: 40

            Behavior on opacity {
                Widgets.Anim {}
            }

            Rectangle {
                anchors {
                    fill: parent
                    leftMargin: 10
                    rightMargin: 10
                }
                height: 32
                radius: Config.Appearance.rounding.small
                color: Qt.rgba(1, 1, 1, 0.06)
                border.color: searchInput.activeFocus ? Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.55) : Qt.rgba(1, 1, 1, 0.12)
                border.width: 1
                Behavior on border.color {
                    Widgets.ColorAnim {}
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: searchInput.forceActiveFocus()
                }

                Widgets.StyledText {
                    anchors {
                        left: parent.left
                        leftMargin: Config.Appearance.spacing.small
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Search..."
                    font.pixelSize: Config.Appearance.font.size.normal
                    color: Qt.rgba(1, 1, 1, 0.22)
                    visible: searchInput.text === ""
                }

                TextInput {
                    id: searchInput
                    focus: true
                    activeFocusOnPress: true
                    anchors {
                        left: parent.left
                        leftMargin: Config.Appearance.spacing.small
                        rightMargin: Config.Appearance.spacing.smaller
                        top: parent.top
                        bottom: parent.bottom
                    }
                    verticalAlignment: TextInput.AlignVCenter
                    color: Config.Theme.surfaceOn
                    font.pixelSize: Config.Appearance.font.size.normal
                    selectionColor: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.35)
                    clip: true
                }
            }
        }

        Item {
            width: parent.width
            height: parent.height - search.height - parent.spacing

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: width
                contentHeight: appList.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: appList
                    width: flick.width
                    spacing: Config.Appearance.spacing.small

                    Repeater {
                        model: DesktopEntries.applications
                        delegate: Item {
                            id: app
                            required property var modelData
                            implicitWidth: flick.width
                            height: 42

                            Rectangle {

                                width: flick.width
                                height: parent.height + 10
                                anchors.fill: parent
                                anchors.leftMargin: Config.Appearance.spacing.small
                                anchors.rightMargin: Config.Appearance.spacing.small
                                radius: Config.Appearance.rounding.small

                                color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.07)
                                border.color: Qt.rgba(Config.Theme.primary.r, Config.Theme.primary.g, Config.Theme.primary.b, 0.18)
                                Row {
                                    spacing: Config.Appearance.spacing.normal
                                    width: parent.width
                                    height: parent.height
                                    anchors.fill: parent
                                    Image {
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 32
                                        height: 32
                                        source: "image://icon/" + app.modelData.icon
                                        sourceSize: Qt.size(32, 32)
                                    }

                                    Widgets.StyledText {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: app.modelData.name
                                        font.pixelSize: Config.Appearance.font.size.normal
                                        color: Config.Theme.surfaceOn
                                        width: parent.width - 44
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
