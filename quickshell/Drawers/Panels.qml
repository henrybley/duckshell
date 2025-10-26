import qs.Services
import qs.Config
import qs.Modules.Audio as AudioPanel
import qs.Modules.DateTime as DateTimePanel
import qs.Modules.Launcher as Launcher
import qs.Modules.Workspace as WorkspacePanel
import qs.Modules.Session
import qs.Modules.Notifications as Notifications
/*import qs.modules.launcher as Launcher
import qs.modules.dashboard as Dashboard*/
import qs.Modules.Utilities
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities

    readonly property AudioPanel.Wrapper audio: audio
    readonly property DateTimePanel.Wrapper date_time: date_time
    readonly property WorkspacePanel.Wrapper workspace: workspace
    readonly property Session session: session
    readonly property Launcher.Wrapper launcher: launcher
    readonly property Notifications.Wrapper notifications: notifications
    /*readonly property Dashboard.Wrapper dashboard: dashboard
    readonly property Utilities.Wrapper utilities: utilities*/

    anchors.fill: parent
    anchors.margins: Config.style.borderThickness
    anchors.leftMargin: 0

    AudioPanel.Wrapper {
        id: audio

        clip: root.visibilities.session
        screen: root.screen
        //todo don't hardcode this
        visibility: root.visibilities.audio

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: session.width
    }

    DateTimePanel.Wrapper {
        id: date_time

        screen: root.screen
        //todo don't hardcode this
        //visibility: root.visibilities.audio
        visibility: true

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -6
    }

    
    WorkspacePanel.Wrapper {
        id: workspace

        screen: root.screen
        //todo don't hardcode this
        //visibility: root.visibilities.audio
        visibility: true

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.rightMargin: session.width
    }
    
    Launcher.Wrapper {
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

    Notifications.Wrapper {
        id: notifications

        visibilities: root.visibilities
        panel: root

        anchors.top: parent.top
        anchors.right: parent.right
    }
    
}
