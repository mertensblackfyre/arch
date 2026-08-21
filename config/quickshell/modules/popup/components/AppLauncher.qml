pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import "../../services" as Services
import "../../widgets" as Widgets
import "../../config" as Config

Item {
    id: root
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Behavior on opacity {
         
        }

        TextField {
            id: searchInput
            width: parent.width
            height: 40
            placeholderText: "Search apps..."
            font.pixelSize: 16

            onVisibleChanged: if (visible)
                forceActiveFocus()
        }

        ListView {
            id: appList
            width: parent.width
            height: parent.height - searchInput.height - parent.spacing
            clip: true
            spacing: 5 
            model: DesktopEntries.applications.values

            delegate: Item {
               
                width: appList.width
                
                property bool isMatch: modelData.name.toLowerCase().includes(searchInput.text.toLowerCase())
                height: isMatch ? 46 : 0
                visible: height > 0
                
                Behavior on height { 
                }

                Rectangle {
                    anchors.fill: parent
                    color: "white"
                    opacity: mouseArea.containsMouse ? 0.1 : 0
                    radius: Config.Appearance.rounding.small || 4
                    
                    Behavior on opacity {  }
                }

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 12

                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 32
                        height: 32
                        source: "image://icon/" + modelData.icon 
                        sourceSize: Qt.size(32, 32)
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.name
                        color: "white" 
                        font.pixelSize: 14
                        width: parent.width - 44
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        modelData.launch(); 
                        //win.closePanel(); 
                    }
                }
            }
        }
    }
}