import QtQuick
import qs.Services
import qs.Config
import qs.Components

Item {
    id: clock
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property var showTooltip: false
    
    /*Timer {
        id: timer

        interval: 10000
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            console.log("Clock Width ", clock.width)
            console.log("Clock height ", clock.height)
            var globalPos = clock.mapToItem(null, 0, 0)
            console.log("Clock Position on screen: (" + globalPos.x + ", " + globalPos.y + ")")
        }
    }*/
    
    width: textItem.width
    height: textItem.height

    StyledText {
        id: textItem
        
        text: DateTime.timeString
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeNormal
        anchors.right: parent.right
    }

    /*MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: showTooltip = true
        onExited: showTooltip = false
        cursorShape: Qt.PointingHandCursor
        onClicked: function() {
            calendar.visible = !calendar.visible
        }
    }

    Calendar {
        id: calendar
        screen: clock.screen
        visible: false
    }

    StyledTooltip {
        id: dateTooltip
        text: DateTime.dateString
        tooltipVisible: showTooltip && !calendar.visible
        targetItem: clock
        delay: 200
    }*/
}
