// NetworkPop.qml - WiFi/Network popup using PopupContainer
//
//
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import "../../components/"

Item {
    id: root

    // Reference to the button/anchor that triggers this popup
    property Item anchorItem: null
    property var networkService: null

    // State
    property bool popupOpen: false

    PopupContainer {
        id: networkPopup
        isOpen: root.popupOpen
        anchor: root.anchorItem
        backgroundColor: "#1e1e1e"
        cornerRadius: 12
        verticalOffset: 12

        contentComponent: Component {
            Item {
                width: 300
                height: networkList.childrenRect.height + 20

                Column {
                    id: networkList
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 10
                    }
                    spacing: 8

                    // Header
                    Text {
                        color: "#ffffff"
                        font.pixelSize: 14
                        font.bold: true
                        text: "Available Networks"
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#404040"
                    }

                    // Network list items
                    Repeater {
                        model: root.networkService?.networks ?? []

                        delegate: Rectangle {
                            width: networkList.width
                            height: 44
                            color: networkMouse.containsMouse ? "#303030" : "transparent"
                            radius: 6

                            Row {
                                anchors {
                                    fill: parent
                                    leftMargin: 10
                                    rightMargin: 10
                                }
                                spacing: 10

                                // Signal strength icon
                                Text {
                                    text: modelData.signalStrength >= 75 ? "⚡⚡⚡" : modelData.signalStrength >= 50 ? "⚡⚡" : modelData.signalStrength >= 25 ? "⚡" : "○"
                                    color: "#888888"
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                }

                                // Network name
                                Text {
                                    text: modelData.name
                                    color: "#ffffff"
                                    font.pixelSize: 13
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                // Lock icon if secured
                                Text {
                                    text: modelData.secured ? "🔒" : ""
                                    color: "#888888"
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: networkMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.networkService?.connectToNetwork(modelData.ssid);
                                    root.popupOpen = false;
                                }
                            }
                        }
                    }

                    // Empty state
                    Text {
                        visible: (root.networkService?.networks?.length ?? 0) === 0
                        text: "No networks available"
                        color: "#888888"
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#404040"
                    }

                    // Settings button
                    Rectangle {
                        width: networkList.width
                        height: 40
                        color: "#0066cc"
                        radius: 6

                        Text {
                            anchors.centerIn: parent
                            text: "Network Settings"
                            color: "#ffffff"
                            font.pixelSize: 13
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // Trigger settings or action
                                root.networkService?.openSettings?.();
                                root.popupOpen = false;
                            }
                        }
                    }
                }
            }
        }

        onCloseRequested: {
            root.popupOpen = false;
        }
    }

    // Function to toggle popup
    function togglePopup() {
        root.popupOpen = !root.popupOpen;
    }
}
