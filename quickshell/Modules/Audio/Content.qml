import qs.Components
import qs.Services
import qs.Config
import QtQuick

Column {
    id: root

    padding: Config.style.paddingNormal
    spacing: Config.style.spacingNormal

    //anchors.verticalCenter: parent.verticalCenter
    //anchors.left: parent.left


    AudioControl {}
}
