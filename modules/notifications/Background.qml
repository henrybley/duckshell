import qs.Services
import qs.Config
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real contentWidth
    required property real contentHeight

    readonly property real rounding: Config.style.roundingSmall
    readonly property bool flatten: contentHeight < rounding * 2

    ShapePath {
        strokeWidth: 0
        fillColor: Config.colours.backgroundPrimary

        startX: -(rounding * 2) //-300
        startY: 0//Config.style.paddingLarge

        PathLine {
            relativeX: 0
            relativeY: contentHeight + (rounding * 2)
        }
        PathLine {
            relativeX: contentWidth + (rounding * 2)
            relativeY: 0
        }
        PathLine {
            relativeX: 0
            relativeY: -contentHeight - (rounding *2)
        }
        PathLine {
            relativeX: -contentWidth - (rounding *2)
            relativeY: 0
        }
    }
}
