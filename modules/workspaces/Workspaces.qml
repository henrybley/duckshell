import qs.Services
import qs.Config
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property bool visibility

    visible: width > 0
    width: 280
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibility

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
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.emphasized
            }
        }
    ]
    
    Background {
        id: workspacesBG
        contentWidth: content.width
        contentHeight: content.height
    }

    Content {
        id: content
    }
}
