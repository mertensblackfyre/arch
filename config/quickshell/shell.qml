import Quickshell
import "modules/bar"
import "modules/popup"
import "widgets"
import QtQuick
import Quickshell.Io
import "services"

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

    Launcher{
    }

}
