// services/ShellState.qml
pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property bool visible: false
    property real panelWidth: 0
    property real panelHeight: 0
    property string active: ""

    Timer {
        id: destroyTimer
        interval: 250
        repeat: false
        onTriggered: {
            root.visible = false;
            root.active = "";
        }
    }

    function _show(name, w, h) {
        destroyTimer.stop();
        active = name;
        panelWidth = w;
        panelHeight = h;
        visible = true;
        console.log(w, h, name);
    }

    function _hide() {
        panelWidth = 0;
        panelHeight = 0;
        destroyTimer.restart();
    }
}
