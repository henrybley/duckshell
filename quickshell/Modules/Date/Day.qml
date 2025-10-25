import QtQuick
import qs.Services
import qs.Config
import qs.Components

Item {
    id: day
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property var showTooltip: false
    
    width: textItem.width
    height: textItem.height

    StyledText {
        id: textItem
        
        text: Qt.formatDate(DateTime.date, "a")
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeSmaller
        anchors.right: parent.right
    }
}
