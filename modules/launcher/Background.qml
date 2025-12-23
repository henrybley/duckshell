import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real contentWidth
    required property real contentHeight

    readonly property real rounding: Config.style.roundingLarge
    readonly property bool flatten: contentHeight < rounding * 2
    readonly property real roundingY: flatten ? contentHeight / 2 : rounding

    ShapePath {
        id: shapePath

        startX: -rounding
        startY: contentHeight

        strokeWidth: -1
        fillColor: Config.colours.backgroundPrimary

        PathArc {
            relativeX: root.rounding
            relativeY: -root.roundingY
            radiusX: root.rounding
            radiusY: Math.min(root.rounding, root.contentHeight)
            direction: PathArc.Counterclockwise
        }
        PathLine {
            relativeX: 0
            relativeY: -(root.contentHeight - root.roundingY * 2)
        }
        PathArc {
            relativeX: root.rounding
            relativeY: -root.roundingY
            radiusX: root.rounding
            radiusY: Math.min(root.rounding, root.contentHeight)
        }
        PathLine {
            relativeX: root.contentWidth - root.rounding * 2
            relativeY: 0
        }
        PathArc {
            relativeX: root.rounding
            relativeY: root.roundingY
            radiusX: root.rounding
            radiusY: Math.min(root.rounding, root.contentHeight)
        }
        PathLine {
            relativeX: 0
            relativeY: root.contentHeight - root.roundingY * 2
        }
        PathArc {
            relativeX: root.rounding
            relativeY: root.roundingY
            radiusX: root.rounding
            radiusY: Math.min(root.rounding, root.contentHeight)
            direction: PathArc.Counterclockwise
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
