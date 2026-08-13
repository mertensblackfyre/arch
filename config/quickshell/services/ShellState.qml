// services/ShellState.qml
pragma Singleton
import Quickshell

Singleton {
    id: root

    property string activePopup: ""  // "wifi" | "battery" | "volume" | ""

    function toggle(name) {
        activePopup = activePopup === name ? "" : name
    }

    function close() {
        activePopup = ""
    }
}
