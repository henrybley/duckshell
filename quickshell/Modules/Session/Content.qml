pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
//import qs.Utilities
import Quickshell
import QtQuick

Column {
    id: root

    required property PersistentProperties visibilities

    padding: Config.style.paddingLarge

    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left

    spacing: Config.style.spacingLarge

    SessionButton {
        id: logout

        icon: "logout"
        command: ["loginctl", "terminate-user", ""]

        KeyNavigation.down: shutdown

        Connections {
            target: root.visibilities

            function onSessionChanged(): void {
                if (root.visibilities.session)
                    logout.focus = true;
            }

            function onLauncherChanged(): void {
                if (root.visibilities.session && !root.visibilities.launcher)
                    logout.focus = true;
            }
        }
    }

    SessionButton {
        id: shutdown

        icon: "power_settings_new"
        command: ["systemctl", "poweroff"]

        KeyNavigation.up: logout
        KeyNavigation.down: hibernate
    }

    /*AnimatedImage {
        width: Config.style.sessionButtonSize
        height: Config.style.sessionButtonSize
        sourceSize.width: width
        sourceSize.height: height

        playing: visible
        asynchronous: true
        speed: 0.7
        source: Paths.expandTilde(Config.paths.sessionGif)
    }*/

    SessionButton {
        id: hibernate

        icon: "downloading"
        command: ["systemctl", "hibernate"]

        KeyNavigation.up: shutdown
        KeyNavigation.down: reboot
    }

    SessionButton {
        id: reboot

        icon: "cached"
        command: ["systemctl", "reboot"]

        KeyNavigation.up: hibernate
    }

    component SessionButton: StyledRect {
        id: button

        required property string icon
        required property list<string> command

        implicitWidth: Config.style.sessionButtonSize
        implicitHeight: Config.style.sessionButtonSize

        radius: Config.style.roundingLarge
        color: button.activeFocus ? Config.colours.backgroundLight : Config.colours.backgroundDark

        Keys.onEnterPressed: Quickshell.execDetached(button.command)
        Keys.onReturnPressed: Quickshell.execDetached(button.command)
        Keys.onEscapePressed: root.visibilities.session = false

        StateLayer {
            radius: parent.radius
            color: button.activeFocus ? Config.colours.backgroundLight : Config.colours.backgroundDark

            function onClicked(): void {
                Quickshell.execDetached(button.command);
            }
        }

        Icon {
            anchors.centerIn: parent

            text: button.icon
            color: button.activeFocus ? Config.colours.backgroundLight : Config.colours.backgroundDark
            font.pixelSize: Config.style.fontSizeLarge
            font.weight: 500
        }
    }
}
