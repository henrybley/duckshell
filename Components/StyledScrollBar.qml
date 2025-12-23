import qs.Services
import qs.Config
import QtQuick
import QtQuick.Controls

ScrollBar {
    id: root

    contentItem: StyledRect {
        implicitWidth: 6
        opacity: root.pressed ? 1 : root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1) ? 0.8 : 0
        radius: Config.style.roundingFull
        color: Config.colours.backgroundDark

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animation.animDurations.Normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }

    CustomMouseArea {
        z: -1
        anchors.fill: parent

        function onWheel(event: WheelEvent): void {
            if (event.angleDelta.y > 0)
                root.decrease();
            else if (event.angleDelta.y < 0)
                root.increase();
        }
    }
}
