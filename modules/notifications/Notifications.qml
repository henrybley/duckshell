import qs.Config
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    transitions: [
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Config.animation.animDurations.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.expressiveDefaultSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitHeight"
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.emphasized
            }
        }
    ]

    Background {
        id: notificationsBG
        visible: content.visible
        contentWidth: content.width
        contentHeight: content.height
    }

    Content {
        id: content

        visibilities: root.visibilities
    }
}
