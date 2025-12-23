import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real contentWidth
    required property real contentHeight

    readonly property real rounding: Config.style.roundingLarge
    readonly property bool flatten: contentWidth < rounding * 2
    readonly property real roundingX: flatten ? contentWidth / 2 : rounding

    ShapePath {
        id: shapePath

        startX: roundingX * 2
        startY: -rounding

        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary

        PathArc {
            relativeX: -root.roundingX
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentWidth)
            radiusY: root.rounding
        }
        PathLine {
            relativeX: -(root.contentWidth - root.roundingX * 2)
            relativeY: 0
        }
        PathArc {
            relativeX: -root.roundingX
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentWidth)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: 0
            relativeY: root.contentHeight - root.rounding * 2
        }
        PathArc {
            relativeX: root.roundingX
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentWidth)
            radiusY: root.rounding
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: root.contentWidth - root.roundingX * 2
            relativeY: 0
        }
        PathArc {
            relativeX: root.roundingX
            relativeY: root.rounding
            radiusX: Math.min(root.rounding, root.contentWidth)
            radiusY: root.rounding
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
