import QtQuick
import QtQuick.Controls
import Quickshell
import qs.Components
import qs.Config
import qs.Services

Item {
    id: root

    implicitWidth: preBuiltTimers.implicitWidth
    implicitHeight: preBuiltTimers.implicitHeight

    Column {
        id: preBuiltTimers
        Row {
            StyledText {
                text: "Focus"
                MouseArea {
                    anchors.fill: parent
                    onClicked: TimerService.createStartTimer("Focus", 60 * 25)
                }
            }
        }
        Row {
            StyledText {
                text: "Break"
                MouseArea {
                    anchors.fill: parent
                    onClicked: TimerService.createStartTimer("Break", 60 * 5)
                }
            }
        }
    }
}
