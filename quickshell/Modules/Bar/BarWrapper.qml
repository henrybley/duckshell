pragma ComponentBehavior: Bound

import qs.Services
import qs.Config
import "Popouts" as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts

    //readonly property int exclusiveZone: Config.bar.persistent || visibilities.bar ? content.implicitWidth : Settings.border_thickness
    readonly property int exclusiveZone:  Config.style.borderThickness
    property bool isHovered

    /*function checkPopout(y: real): void {
        content.item?.checkPopout(y);
    }*/

    visible: width > Config.style.borderThickness
    implicitWidth: Config.style.borderThickness
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibilities.bar || root.isHovered

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
                property: "implicitWidth"
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.emphasized
            }
        }
    ]

    /*Loader {
        id: content
        active: screen.name === "HDMI-A-1"
        sourceComponent: Bar {}
    }*/
}
