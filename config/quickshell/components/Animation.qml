import QtQuick
import "../configs/" as Config

NumberAnimation {
    duration: Config.Appearance.anim.durations.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Config.Appearance.anim.curves.standard
}
