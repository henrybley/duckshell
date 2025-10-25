import QtQuick
import qs.Services
import qs.Config
import qs.Components

Rectangle {
    id: clock
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property var showTooltip: false
    width: textItem.paintedWidth + 15
    height: textItem.paintedHeight + 8
    color: Config.colours.backgroundPrimary
    radius: Config.style.borderRounding

    Text {
        id: textItem
        
        
        text: DateTime.timeString
        font.family: Config.style.fontFamily
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeLarger
        color: Config.colours.textPrimary
        anchors.centerIn: parent
    }

    MouseArea {
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
    }
}
