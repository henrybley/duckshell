pragma ComponentBehavior: Bound

import qs.Services
import qs.Config
import QtQuick
import QtQuick.Controls

TextField {
    id: root

    color: Config.colours.textPrimary
    placeholderTextColor: Config.colours.textPrimary
    font.family: Config.style.fontFamily
    font.pixelSize: Config.style.fontSizeNormal
    renderType: TextField.NativeRendering
    cursorVisible: !readOnly

    background: null

    cursorDelegate: StyledRect {
        id: cursor

        property bool disableBlink

        implicitWidth: 2
        color: Config.colours.textPrimary
        radius: Config.style.roundingNormal

        Connections {
            target: root

            function onCursorPositionChanged(): void {
                if (root.activeFocus && root.cursorVisible) {
                    cursor.opacity = 1;
                    cursor.disableBlink = true;
                    enableBlink.restart();
                }
            }
        }

        Timer {
            id: enableBlink

            interval: 100
            onTriggered: cursor.disableBlink = false
        }

        Timer {
            running: root.activeFocus && root.cursorVisible && !cursor.disableBlink
            repeat: true
            triggeredOnStart: true
            interval: 500
            onTriggered: parent.opacity = parent.opacity === 1 ? 0 : 1
        }

        Binding {
            when: !root.activeFocus || !root.cursorVisible
            cursor.opacity: 0
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animation.animDurations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }

    Behavior on placeholderTextColor {
        ColorAnimation {
            duration: Config.animation.animDurations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }
}
