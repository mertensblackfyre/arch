import Quickshell
import "modules/bar"
import "modules/popup"
import "config" as Config
import "widgets"
import QtQuick

ShellRoot {
    PanelWindow {
        anchors {
            left: true
            bottom: true
            right: true
            top: true
        }
        color: "transparent"
        exclusiveZone: -1
        mask: Region {}

        Border {}
    }
    Bar {
        id: bar
    }

    Popup {
        id: pop
    }
}
