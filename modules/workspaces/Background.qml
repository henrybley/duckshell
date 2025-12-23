import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root
    required property real contentWidth
    required property real contentHeight

    readonly property real rounding: Config.style.roundingSmall / 2
    readonly property bool flatten: contentWidth < rounding * 2
    readonly property real roundingY: flatten ? contentWidth / 2 : rounding

    ShapePath {
        id: shapePath

        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary
        PathArc {
            relativeX: root.roundingY
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentHeight)
            radiusY: root.rounding
        }
        /*PathLine {
        relativeX: 0
        relativeY: root.contentHeight - root.roundingY - root.rounding
    }*/
        PathArc {
            relativeX: root.roundingY
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentHeight)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: root.contentWidth// + root.roundingY * 4
            relativeY: 0
        }

        PathArc {
            relativeX: root.roundingY
            relativeY: -root.rounding
            radiusX: Math.min(root.rounding, root.contentHeight)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        /*PathLine {
        relativeX: 0
        relativeY: -root.contentHeight + root.roundingY + root.rounding
    }*/

        PathArc {
            relativeX: root.roundingY
            relativeY: -root.rounding
            radiusX: Math.min(root.rounding, root.contentHeight)
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
}
