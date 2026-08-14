// services/ShellState.qml
pragma Singleton
import Quickshell

Singleton {
    id: root

    property string activePopup: ""

    function toggle(name) {
        activePopup = activePopup === name ? "" : name
    }

    function close() {
        activePopup = ""
    }
}
