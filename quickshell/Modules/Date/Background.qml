import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Wrapper wrapper
    readonly property real rounding: Config.style.roundingNormal
    readonly property bool flatten: wrapper.width < rounding * 2
    readonly property real roundingY: flatten ? wrapper.width / 2 : rounding
    property real startX
    property real startY


    ShapePath {
        id: shapePath

        startX: root.startX   
        startY: root.startY
        
        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary
        //fillColor: "blue"
        PathLine {
            relativeX: -(wrapper.width + roundingY + rounding/2)
            relativeY: 0
        }
        PathArc {
            relativeX: root.roundingY
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.wrapper.height)
            radiusY: root.rounding
        }
        PathLine {
            relativeX: 0
            relativeY: root.wrapper.height - (root.roundingY + root.rounding)
        }
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.wrapper.width)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        //todo figure out why this math is failing
        PathLine {
            relativeX: root.wrapper.width - (root.rounding *1.48)// + root.rounding)
            relativeY: 0
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: root.roundingY //Math.min(root.rounding, root.wrapper.height)
            radiusY: root.roundingY
            //direction: PathArc.Counterclockwise
        }
        /*PathLine {
            relativeX: 0
            relativeY: -root.wrapper.height + root.roundingY + root.rounding
        }*/
        
        /*PathArc {
            relativeX: root.roundingY
            relativeY: -root.rounding
            radiusX: Math.min(root.rounding, root.wrapper.height)
            radiusY: root.rounding
            //direction: PathArc.Counterclockwise
        }*/
       
        Behavior on fillColor {
            ColorAnimation {
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }
}
