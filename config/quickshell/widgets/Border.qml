pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import "../config" as Config

Rectangle {
    id: border
    property alias borderSize: maskInner.anchors.margins
    property alias barSize: maskInner.anchors.leftMargin
    anchors.fill: parent
    color: Config.Theme.background

    layer.enabled: true
    layer.effect: MultiEffect {
        maskSource: mask
        maskEnabled: true
        maskInverted: true
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1
    }
    z: -1

    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            id: maskInner
            anchors.fill: parent
            anchors.margins: 8
            anchors.leftMargin: 35 + 8
            radius: Config.Appearance.rounding.large
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 3
            width: 800
            height: Config.Appearance.rounding.small + 30
            radius: Config.Appearance.rounding.large
        }
    }
}
