import qs.Config
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibilities.session && Config.session.enabled

        PropertyChanges {
            root.implicitWidth: content.implicitWidth
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            NumberAnimation {
                target: root
                property: "implicitWidth"
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.expressiveDefaultSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            NumberAnimation {
                target: root
                property: "implicitWidth"
                duration: root.visibilities.audio ? Config.animation.animDurations.normal : Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: root.visibilities.audio ? Config.animation.animCurves.expressiveDefaultSpatial : Config.animation.animCurves.emphasized
            }
        }
    ]

    Content {
        id: content

        visibilities: root.visibilities
    }
}
