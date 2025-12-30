import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real contentWidth
    required property real contentHeight
    readonly property real rounding: Config.style.roundingSmall

    ShapePath {
        id: shapePath

        startX: -rounding*1.4
        startY: rounding*2.1
        
        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary
        //fillColor: "blue"
        PathArc {
            relativeX: root.rounding
            relativeY: -root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: -root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
        }
        
        PathLine {
            relativeX: contentWidth + root.rounding*4.3
            relativeY: 0
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: -root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: 0 
            relativeY: contentHeight + root.rounding
        }
       
        Behavior on fillColor {
            ColorAnimation {
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }
}
