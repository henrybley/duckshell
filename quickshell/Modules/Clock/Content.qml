import qs.Components
import qs.Services
import qs.Config
import QtQuick

Row {
    id: root

    property int clockHeight: clock.height
    property int clockWidth: clock.width
    padding: Config.style.paddingSmall
    spacing: Config.style.spacingSmall
    width: clock.width + fullDate.width

    Clock {
        id: clock
        screen: modelData
        //anchors.verticalCenter: dash.verticalCenter
    }
    
    Column {
        id: fullDate
        spacing: -14
        anchors.verticalCenter: day.verticalCenter
        StyledText {
            id: space
            
            text: "-"
            color: Config.colours.accentPrimary
            font.weight: Font.Bold
            font.pixelSize: Config.style.fontSizeLarge
            anchors.right: parent.right
        }
        

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: -6
            Day {
                id: day
                screen: modelData
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Date {
                id: date
                screen: modelData
            }
            
            Month {
                id: month
                screen: modelData
            }

            
            
        }
    }

}
