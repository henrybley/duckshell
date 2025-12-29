import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Components
import qs.Config
import qs.Services

Item {
    id: root
    
    enum ViewState {
        New,
        Open,
        Closed
    }
    property int viewState: NotificationDetails.ViewState.New

    readonly property int padding: Config.style.paddingSmall
    readonly property int rounding: Config.style.roundingSmall
    
    implicitWidth: notificationsListShouldBeVisible() ? notificationsList.width : notificationButtonsItem.width
    implicitHeight: notificationsWrapper.implicitHeight
    
    function getModelForViewState() {
        switch(viewState) {
            case NotificationDetails.ViewState.Open: return Notifs.openNotifications;
            case NotificationDetails.ViewState.Closed: return Notifs.closedNotifications;
            default: return Notifs.newNotifications;
        }
    }
    
    function notificationButtonsShouldBeVisible() {
        if (root.viewState === NotificationDetails.ViewState.Open) return true;
        if (root.viewState === NotificationDetails.ViewState.Closed) return true;
        return false;
    }
    function notificationsListShouldBeVisible() {
        if (root.viewState === NotificationDetails.ViewState.Open && Notifs.openNotifications.length > 0) return true;
        if (root.viewState === NotificationDetails.ViewState.Closed && Notifs.closedNotifications.length > 0) return true;
        if (root.viewState === NotificationDetails.ViewState.New && Notifs.newNotifications.length > 0) return true;
        return false;
    }

    Column {
        id: notificationsWrapper
        spacing: padding
        
        NotificationsList {
            id: notificationsList
            visible: root.notificationsListShouldBeVisible()
            model: root.getModelForViewState()
            maxHeight: 300
            showCloseButton: true
        }

        Item {
            id: notificationButtonsItem
            visible: root.notificationButtonsShouldBeVisible()

            implicitWidth: notificationButtons.implicitWidth + Config.style.paddingLarger * 2
            implicitHeight: notificationButtons.implicitHeight + Config.style.paddingLarger//Math.max(row.implicitHeight, Config.style.fontSizeLarge) + Config.style.paddingLarger * 2

            Row {
                id: notificationButtons

                 anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Config.style.paddingLarger
                    rightMargin: Config.style.paddingLarger
                    verticalCenter: parent.verticalCenter
                }

                spacing: Config.style.paddingLarger

                StyledRect {
                    id: dndNotificationsButton

                    implicitWidth: dndIcon.implicitWidth + padding * 4
                    implicitHeight: dndIcon.implicitHeight + padding

                    color: Config.colours.surface
                    radius: Config.style.roundingFull

                    Icon {
                        id: dndIcon
                        anchors.centerIn: parent
                        text: !Notifs.dnd ? "notifications_off" : "notifications"
                        font.pixelSize: Config.style.fontSizeLarge
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Notifs.toggleDnd()
                        }
                    }
                }

                StyledRect {
                    id: closedNotificationsButton

                    implicitWidth: closedNotificationsIcon.implicitWidth + padding * 4
                    implicitHeight:closedNotificationsIcon.implicitHeight + padding

                    color: Config.colours.surface
                    radius: Config.style.roundingFull

                    Icon {
                        id: closedNotificationsIcon
                        anchors.centerIn: parent

                        text: root.viewState == NotificationDetails.ViewState.Open ? "archive" : "notifications_unread" 
                        font.pixelSize: Config.style.fontSizeLarge
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.viewState == NotificationDetails.ViewState.Open ? root.viewState = NotificationDetails.ViewState.Closed : root.viewState = NotificationDetails.ViewState.Open
                        }
                    }
                }
            }
        }
    }
}
