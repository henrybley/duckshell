import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Components
import qs.Config
import qs.Services

Item {
    id: root

    readonly property var notifs: Notifs
    required property PersistentProperties visibilities
    readonly property int padding: Config.style.paddingSmall
    readonly property int rounding: Config.style.roundingSmall

    visible: notifs.recentNotifications.length > 0

    anchors.top: parent.top
    anchors.right: parent.right
    implicitWidth: notificationsWrapper.width + padding
    implicitHeight: notificationsWrapper.height + padding

    ColumnLayout {
        id: notificationsWrapper
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 16

        // Header row
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Notifications icon
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Qt.rgba(0.1, 0.1, 0.1, 0.1)

                Icon {
                    text: notifs.dnd ? "notifications" : "notifications_active"
                    anchors.centerIn: parent
                    color: Config.colours.textPrimary
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: notifs.toggleDnd()
                }
            }

            Text {
                text: "Notifications"
                font.pixelSize: 16
                color: Config.colours.textPrimary
            }

            Item {
                Layout.fillWidth: true
            }

            // Clear all button
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Qt.rgba(0.2, 0.2, 0.2, 0.2)
                visible: notifs.recentNotifications.length > 0

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: notifs.clearAll()
                }

                Icon {
                    anchors.centerIn: parent
                    text: "clear_all"
                }
            }
        }

        // Notifications List
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            radius: 12
            color: Qt.rgba(0, 0, 0, 0.05)

            ListView {
                id: notificationsList
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                clip: true

                model: notifs.recentNotifications

                delegate: Rectangle {
                    width: notificationsList.width
                    height: 80
                    radius: 8
                    color: modelData.urgency === 2 ? "red" : Qt.rgba(1, 1, 1, 0.1)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: modelData.appName || "App"
                                font.pixelSize: 12
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            Text {
                                text: modelData.timeString
                                font.pixelSize: 10
                                opacity: 0.5
                            }
                            Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: notifs.deleteNotification(modelData)
                                }
                                Text {
                                    anchors.centerIn: parent
                                    text: "✕"
                                    font.pixelSize: 12
                                }
                            }
                        }

                        Text {
                            text: modelData.summary
                            font.pixelSize: 14
                            font.bold: true
                        }
                        Text {
                            text: modelData.body
                            font.pixelSize: 12
                            opacity: 0.8
                            visible: modelData.body.length > 0
                        }
                    }
                }

                // Empty state
                Text {
                    anchors.centerIn: parent
                    visible: notifs.recentNotifications.length === 0
                    text: notifs.dnd ? "Do Not Disturb is enabled\n🔕" : "No notifications\n📭"
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
