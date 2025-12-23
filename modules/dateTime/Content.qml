import qs.Components
import qs.Services
import qs.Config
import QtQuick

Row {
    id: root

    padding: 0
    spacing: Config.style.spacingSmall
    width: clock.width + full_date.width

    Clock {
        id: clock
        screen: modelData
        //anchors.verticalCenter: dash.verticalCenter
    }
    
    StyledText {
        id: day
        
        text: Qt.formatDateTime(DateTime.date, "ddd").toUpperCase()
        color: Config.colours.accentPrimary
        font.weight: Font.Bold
    }
    StyledText {
        id: full_date
        
        text: Qt.formatDate(DateTime.date, "yyyy-MM-dd")
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeNormal
    }
}
