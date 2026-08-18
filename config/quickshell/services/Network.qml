// services/Network.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property var networks: []
    property var needsPassword: ({})
    property bool scanning: false
    property bool wifiEnabled: true
    property string connectingTo: ""
    property string forgetSsid: ""
    property string expandSsid: ""

    readonly property var current: {
        for (var i = 0; i < networks.length; i++)
            if (networks[i].inUse)
                return networks[i];
        return null;
    }

    readonly property var available: {
        var r = [];
        for (var i = 0; i < networks.length; i++)
            if (!networks[i].inUse)
                r.push(networks[i]);
        return r;
    }

    Process {
        id: scanProc
        command: []
        running: false
        stdout: SplitParser {
            onRead: function (line) {
                var t = line.trim();
                if (t === "")
                    return;
                var lastC = t.lastIndexOf(":");
                if (lastC < 0)
                    return;
                var security = t.substring(lastC + 1);
                var t2 = t.substring(0, lastC);
                var secC = t2.lastIndexOf(":");
                if (secC < 0)
                    return;
                var signalStr = t2.substring(secC + 1);
                var t3 = t2.substring(0, secC);
                var firstC = t3.indexOf(":");
                if (firstC < 0)
                    return;
                var inUseStr = t3.substring(0, firstC);
                var ssid = t3.substring(firstC + 1).replace(/\\:/g, ":");
                if (ssid === "" || ssid === "--")
                    return;
                var inUse = inUseStr.trim() === "*";
                var signal = parseInt(signalStr.trim()) || 0;
                var secured = security.trim() !== "" && security.trim() !== "--";
                var nets = root.networks.slice();
                var found = false;
                for (var i = 0; i < nets.length; i++) {
                    if (nets[i].ssid === ssid) {
                        if (inUse || signal > nets[i].signal)
                            nets[i] = {
                                ssid: ssid,
                                signal: signal,
                                secured: secured,
                                inUse: inUse
                            };
                        found = true;
                        break;
                    }
                }
                if (!found)
                    nets.push({
                        ssid: ssid,
                        signal: signal,
                        secured: secured,
                        inUse: inUse
                    });
                root.networks = nets.slice();
            }
        }

        onRunningChanged: {
            if (!running) {
                root.scanning = false;
            }
        }
    }

    Process {
        id: connectProc
        command: []
        running: false
        property string _ssid: ""
        stdout: StdioCollector {
            id: connectStdout
        }
        stderr: StdioCollector {
            id: connectStderr
        }
        onExited: function (code, status) {
            console.log("stdout:", connectStdout.text);
            console.log("stderr:", connectStderr.text);
            if (code === 0) {
                var np = Object.assign({}, root.needsPassword);
                delete np[connectProc._ssid];
                root.needsPassword = np;
                root.expandSsid = "";
            } else {
                var err = (connectStdout.text + connectStderr.text).toLowerCase();
                if (err.indexOf("secret") >= 0 || err.indexOf("password") >= 0 || err.indexOf("no network") < 0) {
                    root.expandSsid = connectProc._ssid;
                }
            }
            root.connectingTo = "";
            root.scan(false);
        }
    }

    Process {
        id: passProc
        command: []
        running: false
        onRunningChanged: if (!running) {
            root.connectingTo = "";
            root.expandSsid = "";
            root.scan(false);
        }
    }

    Process {
        id: actionProc
        command: []
        running: false
        onRunningChanged: if (!running) {
            root.connectingTo = "";
            root.forgetSsid = "";
            root.expandSsid = "";
            root.needsPassword = ({});
            root.scan(false);
        }
    }

    Process {
        id: nmtuiProc
        command: ["ghostty", "--title", "nmtui", "nmtui"]
        running: false
    }

    Process {
        id: radioCheckProc
        command: ["bash", "-c", "nmcli radio wifi"]
        running: false
        stdout: SplitParser {
            onRead: function (line) {
                root.wifiEnabled = line.trim() === "enabled";
            }
        }
    }

    Process {
        id: radioProc
        command: []
        running: false

        onRunningChanged: if (!running) {
            radioCheckProc.running = false;
            radioCheckProc.running = true;
        }
    }

    function scan(rescan) {
        if (scanning || !root.wifiEnabled)
            return;
        scanning = true;
        networks = [];
        scanProc.command = ["bash", "-c", "nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list " + (rescan ? "--rescan yes" : "--rescan no") + " 2>/dev/null"];
        scanProc.running = false;
        scanProc.running = true;
    }

    function disconnect() {
        actionProc.command = ["bash", "-c", "nmcli con down \"$(nmcli -t -f NAME,TYPE con show --active" + " | grep ':802-11-wireless' | head -1 | cut -d: -f1)\" 2>/dev/null"];
        actionProc.running = false;
        actionProc.running = true;
    }

    function forget(ssid) {
        actionProc.running = false;
        forgetSsid = "";
        actionProc.command = ["bash", "-c", "for uuid in $(nmcli -g UUID,TYPE connection show | awk -F: '$2==\"802-11-wireless\"{print $1}'); do " + "if [ \"$(nmcli -g 802-11-wireless.ssid connection show \"$uuid\" 2>/dev/null)\" = \"" + ssid + "\" ]; then " + "nmcli connection delete \"$uuid\"; fi; done"];
        actionProc.running = true;
    }

    function connectFirst(ssid) {
        connectingTo = ssid;
        expandSsid = "";
        connectProc._ssid = ssid;
        connectProc.command = ["bash", "-c", "nmcli con up id \"" + ssid + "\" 2>&1 || nmcli dev wifi connect \"" + ssid + "\" 2>&1"];
        connectProc.running = false;
        connectProc.running = true;
    }

    function connectWithPassword(ssid, password) {
        connectingTo = ssid;
        expandSsid = "";
        var np = Object.assign({}, root.needsPassword);
        delete np[ssid];
        root.needsPassword = np;
        passProc.command = ["bash", "-c", "nmcli dev wifi connect \"" + ssid + "\" password \"" + password + "\" 2>/dev/null"];
        passProc.running = false;
        passProc.running = true;
    }

    function openNmtui() {
        nmtuiProc.running = false;
        nmtuiProc.running = true;
    }

    function setWifiEnabled(on) {
        wifiEnabled = on;
        radioProc.command = ["bash", "-c", "nmcli radio wifi " + (on ? "on" : "off")];
        radioProc.running = false;
        radioProc.running = true;
    }

    Component.onCompleted: {
        console.log("WifiService started");
        radioCheckProc.running = true;
        scan(false);
    }
}
