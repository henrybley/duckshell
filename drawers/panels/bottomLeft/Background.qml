import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real contentWidth
    required property real contentHeight
    readonly property real rounding: Config.style.roundingSmall

    property bool flatten: rounding * 2 > contentHeight 

    ShapePath {
        id: shapePath

        startY: -rounding
        
        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: root.contentWidth - (root.rounding*1.8)
            relativeY: 0
        }
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
        }
        
        PathLine {
            relativeX: 0
            relativeY: root.flatten ? 0 :contentHeight - (root.rounding * 2.4)
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: root.rounding
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: -contentWidth - (root.rounding * 2)
            relativeY: 0
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
