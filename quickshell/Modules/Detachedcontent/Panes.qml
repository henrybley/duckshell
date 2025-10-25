pragma ComponentBehavior: Bound

import "Bluetooth"
import qs.Components
import qs.Services
import qs.Config
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ClippingRectangle {
    id: root

    required property Session session

    topRightRadius: Config.style.roundingNormal
    bottomRightRadius: Config.style.roundingNormal
    color: "transparent"

    ColumnLayout {
        id: layout

        spacing: 0
        y: -root.session.activeIndex * root.height

        Pane {
            index: 0
            sourceComponent: Item {
                StyledText {
                    anchors.centerIn: parent
                    text: qsTr("Work in progress")
                    color: Colours.palette.m3outline
                    font.pixelSize: Config.style.fontSizeLarge
                    font.weight: 500
                }
            }
        }

        Pane {
            index: 1
            sourceComponent: BtPane {
                session: root.session
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }

    InnerBorder {
        leftThickness: 0
    }

    component Pane: Item {
        id: pane

        required property int index
        property alias sourceComponent: loader.sourceComponent

        implicitWidth: root.width
        implicitHeight: root.height

        Loader {
            id: loader

            anchors.fill: parent
            asynchronous: true
            active: {
                if (root.session.activeIndex === pane.index)
                    return true;

                const ly = -layout.y;
                const ty = pane.index * root.height;
                return ly + root.height > ty && ly < ty + root.height;
            }
        }
    }
}
