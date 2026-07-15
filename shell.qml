pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "Services" as QsServices
import qs.drawers

ShellRoot {
    id: root

    readonly property var notifs: QsServices.Notifs

    NotificationServer {
        id: notificationServer

        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            console.log("📬 [ShellRoot] Notification received:", notif.appName, notif.summary);
            notif.tracked = true;
            notifs.addNotification(notif);
        }

        Component.onCompleted: {
            console.log("🔔 NotificationServer registered on D-Bus");
        }
    }

    Drawers {}

    Shortcuts {}
}
