import qs.Services
import qs.Config
import qs.modules.audio
import qs.modules.dateTime
import qs.modules.launcher
import qs.modules.workspaces
import qs.modules.session
import qs.modules.notifications
/*import qs.modules.launcher as Launcher
import qs.modules.dashboard as Dashboard*/
//import qs.Modules.Utilities
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    readonly property Audio audio: audio

    anchors.fill: parent
    anchors.margins: Config.style.borderThickness
    anchors.leftMargin: 0

    DateTime {
        id: date_time

        screen: root.screen
        //todo don't hardcode this
        //visibility: root.visibilities.audio
        visibility: true

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -6
    }

    Audio {
        id: audio

        clip: root.visibilities.session
        screen: root.screen
        visibility: root.visibilities.audio


        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: session.width
    }

    Workspaces {
        id: workspace

        screen: root.screen
        //todo don't hardcode this
        //visibility: root.visibilities.audio
        visibility: true

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.rightMargin: session.width
    }

    Launcher {
        id: launcher

        visibilities: root.visibilities

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    Session {
        id: session

        visibilities: root.visibilities

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
    }

    Notifications {
        id: notifications

        visibilities: root.visibilities

        anchors.top: parent.top
        anchors.right: parent.right
    }
}
