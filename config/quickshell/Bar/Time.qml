// Time.qml
import QtQuick
import "../components/"

Column {
    id: clock
    spacing: 0

    function updateTime() {
        const now = new Date();

        let h = now.getHours();        // 0–23
        const m = now.getMinutes();
        const s = now.getSeconds();

        const ap = h >= 12 ? "PM" : "AM";

        h = h % 12;
        if (h === 0)
            h = 12;

        hour.text = h.toString().padStart(2, "0");
        minute.text = m.toString().padStart(2, "0");
        second.text = s.toString().padStart(2, "0");
        ampm.text = ap;
    }

    Component.onCompleted: updateTime()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.updateTime()
    }

    Text {
        id: hour
        font.bold: true
        color: "white"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: minute

        font.bold: true
        color: "white"
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: second
        color: "#aaaaaa"
        font.bold: true
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: ampm
        color: "#777777"
        font.bold: true
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
    }

}
