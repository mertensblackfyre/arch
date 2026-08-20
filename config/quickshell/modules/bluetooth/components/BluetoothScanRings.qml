// modules/bluetooth/components/BluetoothScanRings.qml
pragma ComponentBehavior: Bound
import QtQuick
import "../../../config" as Config
import "../../../widgets" as Widgets
import "../../../services" as Services

Item {
    id: ringsRoot
    property string centerGlyph: "󰂯"
    property int glyphSize: 18

    Repeater {
        model: 4
        delegate: Rectangle {
            required property int index
            anchors.centerIn: parent
            width: ringsRoot.width
            height: ringsRoot.width
            radius: ringsRoot.width / 2
            color: "transparent"
            border.color: Qt.rgba(Config.Theme.tertiary.r, Config.Theme.tertiary.g, Config.Theme.tertiary.b, 0.80)
            border.width: 1.5
            opacity: 0
            scale: 0.08

            SequentialAnimation {
                running: Services.Bluetooth.scanning
                loops: Animation.Infinite
                PauseAnimation {
                    duration: index * 650
                }
                ParallelAnimation {
                    Widgets.Anim {
                        property: "scale"
                        from: 0.08
                        to: 1.0
                        duration: 2200
                        easing.type: Easing.OutCubic
                    }
                    Widgets.Anim {
                        property: "opacity"
                        from: 0.80
                        to: 0.0
                        duration: 2200
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: ringsRoot.centerGlyph
        font.pixelSize: ringsRoot.glyphSize
        color: Qt.rgba(Config.Theme.tertiary.r, Config.Theme.tertiary.g, Config.Theme.tertiary.b, 0.55)
        SequentialAnimation on opacity {
            running: Services.Bluetooth.scanning
            loops: Animation.Infinite
            Widgets.Anim {
                to: 0.20
                duration: 700
                easing.type: Easing.InOutSine
            }
            Widgets.Anim {
                to: 0.80
                duration: 700
                easing.type: Easing.InOutSine
            }
        }
    }
}
