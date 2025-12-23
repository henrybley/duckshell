import qs.Config
import QtQuick

Rectangle {
    id: root

    color: "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }
}
