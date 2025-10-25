import QtQuick
import qs.Services
import qs.Config
import qs.Components

Item {
    id: date
    property var screen: (typeof modelData !== 'undefined' ? modelData : null)
    property var showTooltip: false
    
    width: textItem.width
    height: textItem.height

    StyledText {
        id: textItem
        
        text: Qt.formatDate(DateTime.date, "dd")
        font.weight: Font.Bold
        font.pixelSize: Config.style.fontSizeSmaller
        anchors.right: parent.right
    }
}
