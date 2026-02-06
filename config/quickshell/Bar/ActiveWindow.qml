// ActiveWindow.qml

import Quickshell.Io
import QtQuick
import "../themes/"

Item {
    id: activeWindowContainer
    implicitWidth: parent.width
    implicitHeight: 120

    property string appClass: "DESKTOP"

    property var windowQuery: Process {
        id: hyprCmd
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.class'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let result = this.text.trim();
                console.log(result);
                if (result === "null" || result === "") {
                    activeWindowContainer.appClass = "DESKTOP";
                } else {
                    activeWindowContainer.appClass = result;
                }
            }
        }
    }

    Timer {
        interval: 750
        running: true
        repeat: true
        onTriggered: {
            hyprCmd.running = false;
            hyprCmd.running = true;
        }
    }

    Text {
        anchors.centerIn: parent
        text: activeWindowContainer.appClass
        color: ThemeManager.palette.m3primary
        font.pixelSize: 14
        font.bold: true
        rotation: 270
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }
}
