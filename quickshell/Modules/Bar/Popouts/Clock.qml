import QtQuick
import qs.Services
import qs.Config
import qs.Components

Item {
    id: clock
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property var showTooltip: false
    
    Component.onCompleted: {
        console.log("Item Width " + width)
        console.log("Item height " + height)
        var globalPos = clock.mapToItem(null, 0, 0)
        console.log("Item Position on screen: (" + globalPos.x + ", " + globalPos.y + ")")
    }

    StyledText {
        id: textItem
        
        text: DateTime.timeString
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeLarger
        anchors.right: parent.right
        onWidthChanged: {
            //clock.width = width
            //clock.height = height
            if (width > 0) {
                console.log("Text initialized. Clock width = " + clock.width + ", height = " + clock.height)
            }
        }
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
