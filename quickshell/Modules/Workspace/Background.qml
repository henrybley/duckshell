import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Wrapper wrapper
    readonly property real rounding: Config.style.roundingSmall / 2
    readonly property bool flatten: wrapper.width < rounding * 2
    readonly property real roundingY: flatten ? wrapper.width / 2 : rounding

    strokeWidth: -1
    fillColor: Config.colours.backgroundPrimary
    PathArc {
        relativeX: root.roundingY
        relativeY: root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.height)
        radiusY: root.rounding
    }
    /*PathLine {
        relativeX: 0
        relativeY: root.wrapper.height - root.roundingY - root.rounding
    }*/
    PathArc {
        relativeX: root.roundingY
        relativeY: root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.height)
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }
    PathLine {
        relativeX: root.wrapper.width// + root.roundingY * 4
        relativeY: 0
    }
    
    PathArc {
        relativeX: root.roundingY
        relativeY: -root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.height)
        radiusY: root.rounding
        direction: PathArc.Counterclockwise
    }
    /*PathLine {
        relativeX: 0
        relativeY: -root.wrapper.height + root.roundingY + root.rounding
    }*/
    
    PathArc {
        relativeX: root.roundingY
        relativeY: -root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.height)
        radiusY: root.rounding
        //direction: PathArc.Counterclockwise
    }
   
    Behavior on fillColor {
        ColorAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }
}
