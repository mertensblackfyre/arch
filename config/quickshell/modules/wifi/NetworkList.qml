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
           property int    glyphSize:   18
           Repeater {
               model: 4
               delegate: Rectangle {
                   required property int index
                   anchors.centerIn: parent
                   width: ringsRoot.width
             //      height: ringsRoot.width
                   radius: ringsRoot.width / 2
                   color: "red"
                   border.color: Config.Theme.tertiary
                   border.width: 1.5;
                   SequentialAnimation {
                       running: Services.Network.scan;
                       loops: Animation.Infinite
                       PauseAnimation { duration: 650 }
                       ParallelAnimation {
                           Widgets.Anim{}
                           Widgets.Anim{}
                       }
                   }
               }
           }

           Text {

               anchors.centerIn: parent;
               text: ringsRoot.centerGlyph;
               font.pixelSize: ringsRoot.glyphSize
               color: Config.Theme.inversePrimary
               SequentialAnimation on opacity {
                   running: Services.Network.scan;
                   loops: Animation.Infinite

                   Widgets.Anim{}
               }
           }
       }


       Column {
              anchors.fill: parent
              spacing: 4
              Item {
                  width: parent.width
                  height: 160
                  visible: Services.Network.scanning && Services.Network.networks.length === 0

                  Component.onCompleted: {
                      console.log("NetworkList started")
                      Qt.callLater(() => {
                          console.log("WifiService networks:", Services.Network.networks.length)
                          console.log("WifiService scanning:", Services.Network.scanning)
                      })
                  }
                  ScanRings {
                      anchors.centerIn: parent
                      width: 96
                      height: 96
                  }
              }
          }
}
