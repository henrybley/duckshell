import qs.Config
import Quickshell.Widgets
import QtQuick

ClippingRectangle {
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
