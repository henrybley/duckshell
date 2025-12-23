pragma Singleton

import QtQuick
import Quickshell
import QtQml

Singleton {
    id: root

    // All notifications (QtObjects)
    property list<QtObject> notifications: []

    // Maximum notifications to keep
    readonly property int maxNotifications: 100

    // Do Not Disturb mode
    property bool dnd: false

    // Reactive recent notifications (last 24h, sorted)
    property var recentNotifications: []

    // Reactive active notifications (not closed)
    readonly property var activeNotifications: notifications.filter(n => !n.closed)

    // --- Update function ---
    function updateRecent() {
        recentNotifications = notifications
            .filter(n => {
                const hoursSinceNotif = (new Date().getTime() - n.timestamp.getTime()) / (1000*60*60);
                return hoursSinceNotif < 24;
            })
            .sort((a,b) => b.timestamp.getTime() - a.timestamp.getTime());
    }

    // --- Add notification ---
    function addNotification(notif) {
        if (dnd && notif.urgency < 2) {
            console.log("🔕 DND active, suppressing notification:", notif.summary);
            return;
        }

        const notifWrapper = notifComponent.createObject(root, { notification: notif });

        notifications = [notifWrapper, ...notifications].slice(0, maxNotifications);
        updateRecent();
    }

    // --- Delete notification ---
    function deleteNotification(notif) {
        notifications = notifications.filter(n => n !== notif);
        notif.destroy();
        updateRecent();
    }

    // --- Clear all notifications ---
    function clearAll() {
        notifications.forEach(n => n.close());
        updateRecent();
    }

    // --- Toggle DND ---
    function toggleDnd() {
        dnd = !dnd;
        console.log("🔕 DND mode:", dnd ? "enabled" : "disabled");
    }

    // --- Cleanup old notifications every hour ---
    Timer {
        interval: 3600000
        repeat: true
        running: true
        triggeredOnStart: false
        onTriggered: {
            const oneDayAgo = new Date().getTime() - (24*60*60*1000);
            notifications = notifications.filter(n => n.timestamp.getTime() > oneDayAgo);
            updateRecent();
        }
    }

    // --- Notification object ---
    Component {
        id: notifComponent
        QtObject {
            id: notifWrapper

            property var notification
            property date timestamp: new Date()
            property bool closed: false

            property string id: ""
            property string summary: ""
            property string body: ""
            property string appName: ""
            property string appIcon: ""
            property string image: ""
            property int urgency: 0
            property list<var> actions: []

            readonly property string timeString: {
                const diff = new Date().getTime() - timestamp.getTime();
                const minutes = Math.floor(diff / 60000);
                const hours = Math.floor(minutes / 60);
                const days = Math.floor(hours / 24);
                if (days>0) return days+"d ago";
                if (hours>0) return hours+"h ago";
                if (minutes>0) return minutes+"m ago";
                return "Just now";
            }

            function close() {
                if (closed) return;
                closed = true;
            }

            function invokeAction(actionId) {
                const action = actions.find(a => a.identifier === actionId);
                if (action && action.invoke) action.invoke();
            }

            Component.onCompleted: {
                if (!notification) return;
                id = notification.id;
                summary = notification.summary;
                body = notification.body;
                appName = notification.appName;
                appIcon = notification.appIcon;
                image = notification.image;
                urgency = notification.urgency;
                actions = notification.actions.map(a => ({
                    identifier: a.identifier,
                    text: a.text,
                    invoke: () => a.invoke()
                }));
            }
        }
    }
}
