pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../../components"
import "../../services"
import "../../themes"

PopupWindow {
    id: root

    property var targetWidget
    required property rect position
    required property int expandDirection
    property bool shouldShow: false

    visible: shouldShow || mainRect.opacity > 0
    
    // Transparent background for the window itself
    color: "transparent"

    anchor {
        item: root.targetWidget
        rect: root.position
        gravity: root.expandDirection
    }

    Rectangle {
        id: mainRect
        implicitWidth: 320
        implicitHeight: 450
        color: ThemeManager.palette.m3surfaceContainer
        radius: 20
        border.color: ThemeManager.palette.m3outline
        border.width: 1

        // Glassmorphism effect (visual only, since real blur is expensive)
        opacity: root.shouldShow ? 1 : 0
        scale: root.shouldShow ? 1 : 0.95
        
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                MaterialIcon {
                    text: "wifi"
                    font.pixelSize: 24
                    color: ThemeManager.palette.m3primary
                }

                StyledText {
                    text: "Networks"
                    font.pixelSize: 20
                    font.bold: true
                    Layout.fillWidth: true
                    color: ThemeManager.palette.m3onSurface
                }
                
                // Wifi Switch
                MouseArea {
                    id: wifiSwitch
                    width: 44
                    height: 24
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NetworkService.toggleWifi()
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: NetworkService.wifiEnabled ? ThemeManager.palette.m3primary : ThemeManager.palette.m3surfaceVariant
                        
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Rectangle {
                            width: 18
                            height: 18
                            radius: 9
                            anchors.verticalCenter: parent.verticalCenter
                            x: NetworkService.wifiEnabled ? 24 : 2
                            color: NetworkService.wifiEnabled ? ThemeManager.palette.m3onPrimary : ThemeManager.palette.m3onSurfaceVariant
                            
                            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: ThemeManager.palette.m3outlineVariant
                opacity: 0.5
            }

            // Network List
            ListView {
                id: networkList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: NetworkService.friendlyWifiNetworks
                spacing: 8
                
                ScrollBar.vertical: ScrollBar {
                    width: 4
                    policy: ScrollBar.AsNeeded
                }

                delegate: Rectangle {
                    id: delegateRoot
                    width: networkList.width
                    height: 56
                    radius: 12
                    color: modelData.active ? ThemeManager.palette.m3primaryContainer : (itemMouse.containsMouse ? ThemeManager.palette.m3surfaceContainerHigh : "transparent")
                    
                    Behavior on color { ColorAnimation { duration: 150 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12
                        
                        MaterialIcon {
                            text: modelData.active ? "signal_wifi_4_bar" : "network_wifi"
                            font.pixelSize: 20
                            color: modelData.active ? ThemeManager.palette.m3onPrimaryContainer : ThemeManager.palette.m3onSurface
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            StyledText {
                                text: modelData.ssid || "Unknown Network"
                                font.pixelSize: 14
                                font.bold: modelData.active
                                color: modelData.active ? ThemeManager.palette.m3onPrimaryContainer : ThemeManager.palette.m3onSurface
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            
                            StyledText {
                                text: modelData.isSecure ? "Secure" : "Open"
                                font.pixelSize: 11
                                opacity: 0.7
                                color: modelData.active ? ThemeManager.palette.m3onPrimaryContainer : ThemeManager.palette.m3onSurface
                            }
                        }

                        StyledText {
                            text: modelData.strength + "%"
                            font.pixelSize: 12
                            color: modelData.active ? ThemeManager.palette.m3onPrimaryContainer : ThemeManager.palette.m3onSurface
                        }
                    }
                    
                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!modelData.active) {
                                NetworkService.connectToWifiNetwork(modelData)
                            }
                        }
                    }
                }

                footer: Item {
                    width: networkList.width
                    height: 10
                }
            }
            
            // Actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                // Rescan Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 24
                    color: rescanMouse.containsMouse ? ThemeManager.palette.m3primary : ThemeManager.palette.m3secondaryContainer
                    
                    Behavior on color { ColorAnimation { duration: 150 } }

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        MaterialIcon {
                            text: "refresh"
                            font.pixelSize: 18
                            color: rescanMouse.containsMouse ? ThemeManager.palette.m3onPrimary : ThemeManager.palette.m3onSecondaryContainer
                        }

                        StyledText {
                            text: "Rescan"
                            font.bold: true
                            color: rescanMouse.containsMouse ? ThemeManager.palette.m3onPrimary : ThemeManager.palette.m3onSecondaryContainer
                        }
                    }
                    
                    MouseArea {
                        id: rescanMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NetworkService.rescanWifi()
                    }
                }
            }
        }
    }
}
