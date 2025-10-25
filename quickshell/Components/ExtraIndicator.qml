import qs.Services
import qs.Config
import QtQuick
import QtQuick.Effects

StyledRect {
    required property int extra

    anchors.right: parent.right
    anchors.margins: Config.style.paddingNormal

    color: Config.colours.textSecondary
    radius: Config.style.roundingSmall

    implicitWidth: count.implicitWidth + Config.style.paddingNormal * 2
    implicitHeight: count.implicitHeight + Config.style.paddingSmall * 2

    layer.enabled: opacity > 0
    layer.effect: MultiEffect {
        shadowEnabled: true
        blurMax: 10
        shadowColor: Config.colours.textPrimary
    }

    opacity: extra > 0 ? 1 : 0
    scale: extra > 0 ? 1 : 0.5

    StyledText {
        id: count

        anchors.centerIn: parent
        animate: parent.opacity > 0
        text: qsTr("+%1").arg(parent.extra)
        color: Colours.palette.m3onTertiary
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Config.animation.animDurations.expressiveFastSpatial
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }

    Behavior on scale {
        NumberAnimation {
            duration: Config.animation.animDurations.expressiveFastSpatial
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.expressiveFastSpatial
        }
    }
}
