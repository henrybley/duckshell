import qs.Config
import QtQuick

ListView {
    id: root

    maximumFlickVelocity: 3000

    rebound: Transition {
        NumberAnimation {
            properties: "x,y"
            duration: Config.animation.animDurations.normal 
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }
}
