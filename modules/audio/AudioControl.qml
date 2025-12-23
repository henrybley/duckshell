import qs.Components
import qs.Services
import qs.Config
import QtQuick.Layouts
import Quickshell

ColumnLayout {
    id: root

    spacing: Config.style.spacingSmall

    VerticalSlider {
        id: volumeSlider

        icon: {
            if (Audio.muted)
                return "no_sound";
            if (value >= 0.5)
                return "volume_up";
            if (value > 0)
                return "volume_down";
            return "volume_mute";
        }

        value: Audio.volume
        onMoved: Audio.setVolume(value)

        implicitWidth: Config.style.verticalSliderWidth
        implicitHeight: Config.style.verticalSliderHeight
    }

    /*StyledRect {
        id: pavuButton

        implicitWidth: implicitHeight
        implicitHeight: icon.implicitHeight + Config.style.paddingSmall * 2

        radius: Config.style.roundingNormal
        color: Config.colours.backgroundLight

        StateLayer {
            function onClicked(): void {
                root.wrapper.hasCurrent = false;
                Quickshell.execDetached(["pavucontrol"]);
            }
        }

        Icon {
            id: icon

            anchors.centerIn: parent
            text: "settings"
        }
    }*/
}
