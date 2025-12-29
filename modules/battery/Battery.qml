import qs.Components
import qs.Services
import qs.Config
import QtQuick
import Quickshell.Services.UPower


Row {
    id: root
    
    property var battery: UPower.displayDevice
    required property real fontSize

    padding: 0
    spacing: Config.style.spacingSmall
    width: batteryIcon.width
    height: batteryIcon.height
    

    Icon {
        id: batteryIcon
        text: getBatteryIcon()
        color: getBatteryColor()
        font.pixelSize: fontSize
    }

    function getBatteryIcon() {
        if (battery.state === UPowerDevice.Charging) {
            return "battery_android_frame_bolt"
        }
         
        let percentage = getBatteryPercentage()
        
        if (percentage >= 95) {
            return "battery_android_frame_full"
        } else if (percentage >= 85) {
            return "battery_android_frame_6"
        } else if (percentage >= 70) {
            return "battery_android_frame_5"
        } else if (percentage >= 55) {
            return "battery_android_frame_4"
        } else if (percentage >= 40) {
            return "battery_android_frame_3"
        } else if (percentage >= 25) {
            return "battery_android_frame_2"
        } else if (percentage >= 10) {
            return "battery_android_frame_1"
        } else {
            return "battery_android_0"
        }
    }
    
    function getBatteryColor() {
        let percentage = getBatteryPercentage()
        // Red when critically low
        if (percentage <= 15) {
            return "#f44336"
        }
        // Orange when low
        else if (percentage <= 30) {
            return "#ff9800"
        }
        // Green when charging
        else if (battery.state === UPowerDevice.Charging) {
            return "#4caf50"
        }
        // Default color
        else {
            return Config.colours.textPrimary
        }
    }

    function getBatteryPercentage() {
        if (!battery) return 0
        
        // Percentage is stored as 0-1, so multiply by 100
        if (battery.percentage > 0) {
            return battery.percentage * 100
        }
        
        // Otherwise calculate from energy values
        if (battery.energyFull > 0 && battery.energy >= 0) {
            return (battery.energy / battery.energyFull) * 100
        }
        
        return 0
    }
}
