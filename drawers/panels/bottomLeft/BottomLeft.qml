import qs.Services
import qs.Config
import qs.Components
import qs.modules.battery
import qs.modules.timers
import qs.modules.notifications
import Quickshell
import QtQuick

Item {
    id: root
    required property ShellScreen screen
    required property bool visibility

    enum OpenPanel {
        None,
        Battery,
        Notifications,
        Timers
    }
    property int openPanel: BottomLeft.OpenPanel.None

    visible: width > 0
    implicitWidth: 0
    implicitHeight: content.implicitHeight

    states: State {
        name: "visible"
        when: root.visibility

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
                duration: Config.animation.animDurations.normal
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

    Background {
        contentWidth: content.width
        contentHeight: content.height
    }

    Column {
        id: content
        spacing: 2
        Item {
            id: batteryDetails
            implicitWidth: batteryDetailsContent.width
            implicitHeight: batteryDetailsContent.height
            visible: root.openPanel == BottomLeft.OpenPanel.Battery

            BatteryDetails {
                id: batteryDetailsContent
            }
        }
        Item {
            id: notificationDetails
            implicitWidth: notificationDetailsContent.width
            implicitHeight: notificationDetailsContent.height
            //visible: root.openPanel == BottomLeft.OpenPanel.Notifications

            NotificationDetails {
                id: notificationDetailsContent
            }
        }

        Item {
            id: timersDetails
            implicitWidth: timerDetailsContent.width
            implicitHeight: timerDetailsContent.height
            visible: root.openPanel === BottomLeft.OpenPanel.Timers

            TimersDetails {
                id: timerDetailsContent
            }
        }
        Item {
            implicitWidth: bottomLeftItems.implicitWidth
            implicitHeight: bottomLeftItems.implicitHeight

            Row {
                id: bottomLeftItems

                Battery {
                    anchors.bottom: parent.bottom
                    fontSize: root.openPanel == BottomLeft.OpenPanel.Battery ? Config.style.fontSizeLarge : Config.style.fontSizeLarger
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.openPanel == BottomLeft.OpenPanel.Battery ? root.openPanel = BottomLeft.OpenPanel.None : root.openPanel = BottomLeft.OpenPanel.Battery
                    }
                }
                Icon {
                    id: notificationsIcon
                    anchors.bottom: parent.bottom
                    text: Notifs.dnd ? "notifications_off" : Notifs.openNotifications.length > 0 ? "notifications_unread" : "notifications"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.openPanel == BottomLeft.OpenPanel.Notifications ? root.openPanel = BottomLeft.OpenPanel.None : root.openPanel = BottomLeft.OpenPanel.Notifications;
                            notificationDetailsContent.viewState = (notificationDetailsContent.viewState === NotificationDetails.ViewState.New) ? NotificationDetails.ViewState.Open : NotificationDetails.ViewState.New;
                        }
                    }
                    font.pixelSize: root.openPanel == BottomLeft.OpenPanel.Notifications ? Config.style.fontSizeLarge : Config.style.fontSizeLarger
                }
                Icon {
                    id: clockIcon
                    anchors.bottom: parent.bottom
                    text: "schedule"
                    font.pixelSize: root.openPanel == BottomLeft.OpenPanel.Timers ? Config.style.fontSizeLarge : Config.style.fontSizeLarger
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.openPanel = (root.openPanel === BottomLeft.OpenPanel.Timers) ? BottomLeft.OpenPanel.None : BottomLeft.OpenPanel.Timers
                    }
                }
                Timers {
                    id: timers
                    anchors.bottom: parent.bottom
                    active: root.openPanel === BottomLeft.OpenPanel.Timers
                }
            }
        }
    }
}
