import ".."
import qs.Components
import qs.Services
import qs.Config
import Quickshell
import Quickshell.Bluetooth
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property Session session

    spacing: Config.style.spacingNormal
}
