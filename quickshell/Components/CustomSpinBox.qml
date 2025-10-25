pragma ComponentBehavior: Bound

import qs.Services
import qs.Config
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property int value
    property real max: Infinity
    property real min: -Infinity
    property alias repeatRate: timer.interval

    signal valueModified(value: int)

    spacing: Config.style.spacingSmall

    StyledTextField {
        inputMethodHints: Qt.ImhFormattedNumbersOnly
        text: root.value
        onAccepted: root.valueModified(text)

        padding: Config.style.paddingSmall
        leftPadding: Config.style.paddingNormal
        rightPadding: Config.style.paddingNormal

        background: StyledRect {
            implicitWidth: 100
            radius: Config.style.roundingSmall
            color: Config.colours.backgroundLightHigh
        }
    }

    StyledRect {
        radius: Config.style.roundingSmall
        color: Config.colours.textPrimary

        implicitWidth: implicitHeight
        implicitHeight: upIcon.implicitHeight + Config.style.paddingSmall * 2

        StateLayer {
            id: upState

            color: Config.colours.backgroundPrimary

            onPressAndHold: timer.start()
            onReleased: timer.stop()

            function onClicked(): void {
                root.valueModified(Math.min(root.max, root.value + 1));
            }
        }

        Icon {
            id: upIcon

            anchors.centerIn: parent
            text: "keyboard_arrow_up"
            color: Config.colours.backgroundPrimary
        }
    }

    StyledRect {
        radius: Config.style.roundingSmall
        color: Config.colours.textPrimary

        implicitWidth: implicitHeight
        implicitHeight: downIcon.implicitHeight + Config.style.paddingSmall * 2

        StateLayer {
            id: downState

            color: Config.colours.backgroundPrimary

            onPressAndHold: timer.start()
            onReleased: timer.stop()

            function onClicked(): void {
                root.valueModified(Math.max(root.min, root.value - 1));
            }
        }

        Icon {
            id: downIcon

            anchors.centerIn: parent
            text: "keyboard_arrow_down"
            color: Config.colours.backgroundPrimary
        }
    }

    Timer {
        id: timer

        interval: 100
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (upState.pressed)
                upState.onClicked();
            else if (downState.pressed)
                downState.onClicked();
        }
    }
}
