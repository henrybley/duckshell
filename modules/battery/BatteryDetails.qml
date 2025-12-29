import qs.Components
import qs.Services
import qs.Config
import QtQuick
import Quickshell.Services.UPower

Item {
    property var battery: UPower.displayDevice
    function getBatteryPercentage() {
        if (!battery) return 0

        if (battery.percentage > 0)
            return Math.round(battery.percentage * 100)

        if (battery.energyFull > 0 && battery.energy >= 0)
            return Math.round((battery.energy / battery.energyFull) * 100)

        return 0
    }
    implicitWidth: batteryDetailsRow.implicitWidth + Config.style.paddingLarger * 2
    implicitHeight: batteryDetailsRow.implicitHeight


    Row {
        id: batteryDetailsRow

        anchors.centerIn: parent
        spacing: Config.style.paddingLarger

        Text {
            id: batteryPercentage
            text: getBatteryPercentage() + "%"
            color: Config.colours.textPrimary
            font.pixelSize: 20
            font.bold: true
        }
    }
}

