// modules/popup/PopupLayer.qml
import Quickshell
import QtQuick
import "../../widgets" as Widgets
import "../../config" as Config

PanelWindow {
    id: root

     property bool open: false
     property Component contentComponent: null
     property int panelWidth: 264
     property int panelMargins: 8
     property int windowWidth: 280
     property bool closeOnOutsideClick: true
     signal outsideClicked()

     anchors.left: true
     anchors.top: true
     anchors.bottom: true
     margins.left: 48
     exclusiveZone: -1
     aboveWindows: true
     color: "red"

     visible: true
     implicitWidth: windowWidth

     MouseArea {
         anchors.fill: parent
         onClicked: {
             if (root.closeOnOutsideClick) {
                 root.outsideClicked()
             }
         }
     }

      Rectangle {
          id: panel
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.margins: root.panelMargins
          width: root.panelWidth
          height: content.implicitHeight + 24
          radius: 16
          color: Config.Theme.background

          // Prevent outside‑click closing when clicking inside the panel
          MouseArea {
              anchors.fill: parent
              onClicked: {}
          }

          Loader {
              id: content
              anchors.fill: parent
              anchors.margins: 12
              sourceComponent: root.contentComponent
          }

          Behavior on width {
              Widgets.Anim { duration: Config.Appearance.anim.durations.small }
          }
          Behavior on height {
              Widgets.Anim { duration: Config.Appearance.anim.durations.small }
          }
      }



      Behavior on implicitWidth {
             Widgets.Anim {}
         }

}
