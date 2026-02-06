// Time.qml
import QtQuick
import QtQuick.Layouts
import "../themes"

ColumnLayout {
    id: clock
    spacing: 1
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

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
        color: ThemeManager.palette.m3tertiary
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        id: minute
        font.bold: true
        color: "#ffffff"
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 13
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 11
        horizontalAlignment: Text.AlignHCenter
    }
}
