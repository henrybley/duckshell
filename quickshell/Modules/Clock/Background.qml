import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Wrapper wrapper
    readonly property real rounding: Config.style.roundingSmall
    readonly property bool flatten: wrapper.width < rounding * 2
    readonly property real roundingY: flatten ? wrapper.content.clockHeight / 2 : rounding
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
            relativeY: root.wrapper.content.clockHeight - (root.rounding*1.8)
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.wrapper.width)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: root.wrapper.content.clockWidth - (root.rounding)// + root.rounding)
            relativeY: 0
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: root.roundingY //Math.min(root.rounding, root.wrapper.height)
            radiusY: root.roundingY
        }
        
        PathLine {
            relativeX: 0
            relativeY: root.wrapper.height - root.wrapper.content.clockHeight - (root.roundingY + root.rounding)
        }
        
        PathArc {
            relativeX: root.rounding
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.wrapper.height)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        
        PathLine {
            relativeX: 5//root.wrapper.width - root.wrapper.content.clockWidth - (root.roundingY*1.5 + root.rounding)
            relativeY: 0
        }
        PathArc {
            relativeX: root.rounding
            relativeY: root.roundingY
            radiusX: Math.min(root.rounding, root.wrapper.height)
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
