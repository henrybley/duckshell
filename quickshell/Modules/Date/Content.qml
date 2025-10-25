import qs.Components
import qs.Services
import qs.Config
import QtQuick

Column {
    id: root

    padding: Config.style.paddingSmall
    spacing: Config.style.spacingSmall
    width: day.width

    
    Day {
        id: day
        screen: modelData
        anchors.verticalCenter: parent.verticalCenter
    }
    
    Date {
        id: date
        screen: modelData
        anchors.verticalCenter: parent.verticalCenter
    }
    
    Month {
        id: month
        screen: modelData
        anchors.verticalCenter: parent.verticalCenter
    }
}
