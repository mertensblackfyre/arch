pragma Singleton
import Quickshell
import QtQuick

Singleton {
    property bool visible: false
    property real panelWidth: 0
    property real panelHeight: 0
    property string active: ""

    function _show(name, w, h) {
        active = name;
        panelWidth = w;
        panelHeight = h;
        visible = true;
        console.log(w, h, name);
    }

    function _hide() {
        visible = false;
        active = "";
        panelWidth = 0;
        panelHeight = 0;
    }
}
