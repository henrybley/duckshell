import qs.Components
import qs.Services
import qs.Config
import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Slider {
    id: root

    required property string icon
    property real oldValue

    wheelEnabled: true

    orientation: Qt.Vertical

    background: StyledRect {
        color: Config.colours.alpha(Config.colours.backgroundPrimary, true)
        radius: Config.style.roundingFull

        StyledRect {
            anchors.left: parent.left
            anchors.right: parent.right

            y: root.handle.y
            implicitHeight: parent.height - y

            color: Config.colours.alpha(Config.colours.backgroundLight, true)
            radius: Config.style.roundingFull
        }
    }

    handle: Item {
        id: handle

        property bool moving

        y: root.visualPosition * (root.availableHeight - height)
        implicitWidth: root.width
        implicitHeight: root.width

        RectangularShadow {
            anchors.fill: parent
            radius: rect.radius
            color: Config.colours.textPrimary
            blur: 5
            spread: 0
        }

        StyledRect {
            id: rect

            anchors.fill: parent

            color: Config.colours.alpha(Config.colours.backgroundDark, true)
            radius: Config.style.roundingFull

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: event => event.accepted = false
            }

            Icon {
                id: icon

                property bool moving: handle.moving

                function update(): void {
                    animate = !moving;
                    text = moving ? Qt.binding(() => Math.round(root.value * 100)) : Qt.binding(() => root.icon);
                    font.pixelSize = moving ? Config.style.verticalSliderWidth - 8 : Config.style.fontSizeLarge;
                    font.family = moving ? Config.style.fontFamily : Config.style.fontFamilyIcons;
                }

                animate: true
                text: root.icon
                color: Config.colours.textPrimary
                anchors.centerIn: parent

                Behavior on moving {
                    SequentialAnimation {
                        NumberAnimation {
                            target: icon
                            property: "scale"
                            from: 1
                            to: 0
                            duration: Config.animation.durationsNormal / 2
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Config.animation.animCurves.standardAccel
                        }
                        ScriptAction {
                            script: icon.update()
                        }
                        NumberAnimation {
                            target: icon
                            property: "scale"
                            from: 0
                            to: 1
                            duration: Config.animation.durationsNormal / 2
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Config.animation.animCurves.standardDecel
                        }
                    }
                }
            }
        }
    }

    onPressedChanged: handle.moving = pressed

    onValueChanged: {
        if (Math.abs(value - oldValue) < 0.01)
            return;
        oldValue = value;
        handle.moving = true;
        stateChangeDelay.restart();
    }

    Timer {
        id: stateChangeDelay

        interval: 500
        onTriggered: {
            if (!root.pressed)
                handle.moving = false;
        }
    }

    Behavior on value {
        NumberAnimation {
            duration: Config.animation.animDurations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.standard
        }
    }
}
