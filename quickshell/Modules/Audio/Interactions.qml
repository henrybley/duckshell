import qs.Services
import qs.Config
import Quickshell
import QtQuick

Scope {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property bool hovered

    function show(): void {
        root.visibilities.audio = true;
        timer.restart();
    }

    Connections {
        target: Audio

        function onMutedChanged(): void {
            root.show();
        }

        function onVolumeChanged(): void {
            root.show();
        }
    }

    Timer {
        id: timer

        interval: Config.animation.hideDelay
        onTriggered: {
            if (!root.hovered)
                root.visibilities.audio = false;
        }
    }
}
