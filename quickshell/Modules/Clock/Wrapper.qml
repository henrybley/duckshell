import qs.Services
import qs.Config
import Quickshell
import QtQuick

Item {
    id: root
    property Content content: content
    required property ShellScreen screen
    required property bool visibility

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight
    
    /*Timer {
        id: timer

        interval: 10000
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            console.log("Clock Wrapper Width ", root.width)
            console.log("Clock Wrapper height ", root.height)
            var globalPos = clock.mapToItem(null, 0, 0)
            console.log("Clock Position on screen: (" + globalPos.x + ", " + globalPos.y + ")")
        }
    }*/

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

    Content {
        id: content
    }
}
