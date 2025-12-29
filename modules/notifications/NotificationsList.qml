import QtQuick
import QtQuick.Controls
import qs.Config
import qs.Components
import qs.Services

Rectangle {
    id: root
    
    // Configurable properties
    property var model: []
    property int maxHeight: 300
    property bool showCloseButton: true
    
    readonly property int padding: Config.style.paddingSmall
    
    width: 300
    height: Math.min(notificationsList.contentHeight + padding * 8, maxHeight)
    radius: 12
    color: Qt.rgba(0, 0, 0, 0.05)
    border.width: 0
    
    ListView {
        id: notificationsList
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        clip: true
        
        model: root.model
        
        delegate: Rectangle {
            width: notificationsList.width
            height: contentColumn.height + (root.padding * 2)
            radius: 8
            color: modelData.urgency === 2 ? "red" : Qt.rgba(1, 1, 1, 0.1)
            
            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: root.padding
                spacing: root.padding
                
                Item {
                    width: parent.width
                    height: 20
                    
                    Text {
                        text: modelData.appName || "App"
                        font.pixelSize: 12
                        color: Config.colours.textPrimary
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: Qt.rgba(0.2, 0.2, 0.2, 0.3)
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        visible: root.showCloseButton
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modelData.close()
                        }
                        
                        Icon {
                            anchors.centerIn: parent
                            text: "close"
                            font.pixelSize: 12
                            color: Config.colours.textPrimary
                        }
                    }
                    
                    Text {
                        text: modelData.timeString
                        font.pixelSize: 10
                        opacity: 0.5
                        color: Config.colours.textPrimary
                        anchors.right: parent.right
                        anchors.rightMargin: root.showCloseButton ? 28 : 0
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                Text {
                    width: parent.width
                    text: modelData.summary
                    font.pixelSize: 14
                    font.bold: true
                    color: Config.colours.textPrimary
                    wrapMode: Text.WordWrap
                }
                
                Text {
                    width: parent.width
                    text: modelData.body
                    font.pixelSize: 12
                    opacity: 0.8
                    visible: modelData.body && modelData.body.length > 0
                    color: Config.colours.textPrimary
                    wrapMode: Text.WordWrap
                }
            }
        }
        
        // Empty state
        Text {
            anchors.centerIn: parent
            visible: notificationsList.count === 0
            text: Notifs.dnd ? "Do Not Disturb is enabled\n🔕" : "No notifications\n📭"
            font.pixelSize: 14
            color: Config.colours.textPrimary
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
