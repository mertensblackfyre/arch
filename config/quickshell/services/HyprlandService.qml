pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

/**
 * Provides access to the active window in Hyprland.
 */
Singleton {
    id: root
    property var activeWindow: null

    function updateActiveWindow() {
        getActiveWindow.running = true;
    }

    function getTruncatedTitle(maxLength = 30) {
        if (!activeWindow || !activeWindow.title)
            return "";
        const title = activeWindow.title;
        return title.length > maxLength ? title.substring(0, maxLength) + "..." : title;
    }

    Component.onCompleted: {
        updateActiveWindow();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (["openlayer", "closelayer", "screencast"].includes(event.name))
                return;
            root.updateActiveWindow();
        }
    }

    Process {
        id: getActiveWindow
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            id: activeWindowCollector
            onStreamFinished: {
                root.activeWindow = JSON.parse(activeWindowCollector.text);
            }
        }
    }
}
