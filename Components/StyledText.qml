pragma ComponentBehavior: Bound

import qs.Services
import qs.Config
import QtQuick

Text {
    id: root

    property bool animate: false
    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: Config.animation.animDurations.normal

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Config.colours.textPrimary
    font.family: Config.style.fontFamily
    font.pixelSize: Config.style.fontSizeNormal
    font.weight: Font.Bold
    lineHeight: font.pixelSize
    lineHeightMode: Text.FixedHeight

    Behavior on color {
        ColorAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            Anim {
                to: root.animateFrom
                easing.bezierCurve: Config.animation.animCurves.standardAccel
            }
            PropertyAction {}
            Anim {
                to: root.animateTo
                easing.bezierCurve: Config.animation.animCurves.standardDecel
            }
        }
    }

    component Anim: NumberAnimation {
        target: root
        property: root.animateProp
        duration: root.animateDuration / 2
        easing.type: Easing.BezierSpline
    }
}
