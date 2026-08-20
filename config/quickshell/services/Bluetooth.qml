// services/Bluetooth.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var allDevices: []
    property bool scanning: false
    property bool btPowered: true
    property string actionMac: ""
    property string removeMac: ""
    property string removingMac: ""
    property string pairingMac: ""

    readonly property var paired: {
        var r = [];
        for (var i = 0; i < allDevices.length; i++)
            if (allDevices[i].paired)
                r.push(allDevices[i]);
        return r;
    }

    readonly property var available: {
        var r = [];
        for (var i = 0; i < allDevices.length; i++)
            if (!allDevices[i].paired)
                r.push(allDevices[i]);
        return r;
    }

    function iconFromName(name) {
        var n = name.toLowerCase();
        if (n.match(/head(phone|set)|earphone|earpad|airpod|buds|wf-|wh-|ep-|tws/))
            return "headphone";
        if (n.match(/speaker|soundbar|boom|jbl|bose|harman|charge|flip|pulse/))
            return "speaker";
        if (n.match(/keyboard|kbd/))
            return "keyboard";
        if (n.match(/mouse|trackpad|trackball|mx master|mx anywhere/))
            return "mouse";
        if (n.match(/phone|iphone|android|galaxy|pixel|oneplus|xperia|redmi/))
            return "phone";
        if (n.match(/macbook|laptop|thinkpad|xps|zenbook|surface/))
            return "laptop";
        if (n.match(/watch|band|garmin|fitbit|amazfit|mi band|polar/))
            return "watch";
        if (n.match(/controller|gamepad|dualshock|dualsense|xbox|joycon|steam/))
            return "gamepad";
        if (n.match(/tv |television|bravia|smart-tv/))
            return "tv";
        return "default";
    }

    function glyph(t) {
        switch (t) {
        case "headphone":
            return "󰋋";
        case "speaker":
            return "󰓃";
        case "keyboard":
            return "󰌌";
        case "mouse":
            return "󰍽";
        case "phone":
            return "󰄜";
        case "laptop":
            return "󰌢";
        case "watch":
            return "󰢗";
        case "gamepad":
            return "󰊖";
        case "tv":
            return "󰔮";
        default:
            return "󰂯";
        }
    }

    Process {
        id: listProc
        command: ["bash", "-c", "echo 'POWERED:'; " + "bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}'; " + "echo 'PAIRED:'; " + "bluetoothctl devices Paired    2>/dev/null | awk '{print $2}'; " + "echo 'CONNECTED:'; " + "bluetoothctl devices Connected 2>/dev/null | awk '{print $2}'; " + "echo 'ALL:'; " + "bluetoothctl devices           2>/dev/null"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.parseDevices(text)
        }
    }

    Process {
        id: scanProc
        command: ["bash", "-c", "trap 'echo scan off | bluetoothctl 2>/dev/null' EXIT; " + "(echo 'power on'; echo 'scan on'; sleep 8) | timeout 9 bluetoothctl 2>/dev/null"]
        running: false
        stdout: SplitParser {
            onRead: function (line) {
                var m = line.match(/\[NEW\]\s+Device\s+([0-9A-Fa-f:]{17})\s+(.+)/);
                if (!m)
                    return;
                var mac = m[1];
                var name = m[2].trim();
                var devs = root.allDevices.slice();
                for (var i = 0; i < devs.length; i++)
                    if (devs[i].mac === mac)
                        return;
                devs.push({
                    mac: mac,
                    name: name,
                    paired: false,
                    connected: false,
                    iconType: root.iconFromName(name)
                });
                root.allDevices = devs;
            }
        }
        onRunningChanged: if (!running) {
            root.scanning = false;
            scanPollTimer.stop();
            root.loadDevices();
        }
    }

    Timer {
        id: scanPollTimer
        interval: 2000
        repeat: true
        running: false
        onTriggered: root.loadDevices()
    }

    Process {
        id: actionProc
        command: []
        running: false
        onRunningChanged: if (!running) {
            root.actionMac = "";
            root.loadDevices();
        }
    }

    Process {
        id: removeProc
        command: []
        running: false
        onRunningChanged: if (!running) {
            root.removingMac = "";
            root.loadDevices();
        }
    }

    Process {
        id: powerProc
        command: []
        running: false
        onRunningChanged: if (!running)
            root.loadDevices()
    }

    Process {
        id: bluemanProc
        command: ["blueman-manager"]
        running: false
    }

    Timer {
        interval: 8000
        repeat: true
        running: true
        onTriggered: if (!root.scanning)
            root.loadDevices()
    }

    function loadDevices() {
        if (listProc.running)
            return;
        listProc.running = false;
        listProc.running = true;
    }

    function parseDevices(raw) {
        var lines = raw.split("\n");
        var mode = "";
        var paired = {};
        var conn = {};
        var known = {};

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (line === "POWERED:") {
                mode = "powered";
                continue;
            } else if (line === "PAIRED:") {
                mode = "paired";
                continue;
            } else if (line === "CONNECTED:") {
                mode = "connected";
                continue;
            } else if (line === "ALL:") {
                mode = "all";
                continue;
            }
            if (line === "")
                continue;
            if (mode === "powered") {
                root.btPowered = line.toLowerCase() === "yes";
            } else if (mode === "paired") {
                paired[line] = true;
            } else if (mode === "connected") {
                conn[line] = true;
            } else if (mode === "all") {
                var parts = line.split(" ");
                if (parts.length < 3 || parts[0] !== "Device")
                    continue;
                var mac = parts[1];
                var name = parts.slice(2).join(" ");
                if (mac && name)
                    known[mac] = name;
            }
        }

        var seenMac = {};
        var devs = [];
        for (var mac in known) {
            if (seenMac[mac])
                continue;
            seenMac[mac] = true;
            devs.push({
                mac: mac,
                name: known[mac],
                paired: !!paired[mac],
                connected: !!conn[mac],
                iconType: root.iconFromName(known[mac])
            });
        }

        var existing = root.allDevices;
        for (var j = 0; j < existing.length; j++) {
            var d = existing[j];
            if (seenMac[d.mac])
                continue;
            seenMac[d.mac] = true;
            devs.push({
                mac: d.mac,
                name: d.name,
                paired: !!paired[d.mac],
                connected: !!conn[d.mac],
                iconType: d.iconType
            });
        }
        root.allDevices = devs;
    }

    function setPower(on) {
        root.btPowered = on;
        if (!on)
            root.allDevices = [];
        powerProc.command = ["bluetoothctl", "power", on ? "on" : "off"];
        powerProc.running = false;
        powerProc.running = true;
    }

    function startScan() {
        if (!root.btPowered)
            return;
        if (root.scanning) {
            root.scanning = false;
            scanProc.running = false;
            scanPollTimer.stop();
            root.loadDevices();
            return;
        }
        root.scanning = true;
        scanProc.running = false;
        scanProc.running = true;
        scanPollTimer.restart();
    }

    function connect(mac) {
        root.actionMac = mac;
        root.pairingMac = "";
        actionProc.command = ["bluetoothctl", "connect", mac];
        actionProc.running = false;
        actionProc.running = true;
    }

    function disconnect(mac) {
        root.actionMac = mac;
        actionProc.command = ["bluetoothctl", "disconnect", mac];
        actionProc.running = false;
        actionProc.running = true;
    }

    function pair(mac, pin) {
        root.actionMac = mac;
        root.pairingMac = "";
        if (pin !== "") {
            actionProc.command = ["bash", "-c", "(echo 'default-agent'; echo 'trust " + mac + "'; echo 'pair " + mac + "'; sleep 1; echo '" + pin + "'; sleep 4) | timeout 12 bluetoothctl 2>/dev/null"];
        } else {
            actionProc.command = ["bash", "-c", "(echo 'default-agent'; echo 'trust " + mac + "'; echo 'pair " + mac + "'; sleep 2; echo 'yes'; sleep 2; echo 'connect " + mac + "'; sleep 3) | timeout 15 bluetoothctl 2>/dev/null"];
        }
        actionProc.running = false;
        actionProc.running = true;
    }

    function remove(mac) {
        root.removeMac = "";
        root.removingMac = mac;
        removeProc.command = ["bash", "-c", "bluetoothctl untrust " + mac + " 2>/dev/null; " + "bluetoothctl disconnect " + mac + " 2>/dev/null; " + "bluetoothctl remove " + mac + " 2>/dev/null"];
        removeProc.running = false;
        removeProc.running = true;
    }

    function openBlueman() {
        bluemanProc.running = false;
        bluemanProc.running = true;
    }

    Component.onCompleted: loadDevices()
}
