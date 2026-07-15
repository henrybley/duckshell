import qs.Components
import qs.Services
import qs.Config
import QtQuick

Item {
    id: root
    required property bool active

    implicitWidth: timersRow.implicitWidth
    implicitHeight: timersRow.implicitHeight
    clip: true

    Row {
        id: timersRow
        spacing: 0

        Repeater {
            model: TimerService.getAllTimers()

            Row {
                spacing: 0

                property color timerColor: {
                    let baseColor = index % 2 === 0
                        ? Config.colours.textSecondary
                        : Config.colours.textTertiary;

                    return modelData.remaining > 0
                        ? baseColor
                        : Config.colours.error;
                }

                StyledText {
                    text: TimerService.formatTime(modelData.remaining)
                    color: parent.timerColor
                }

                Icon {
                    visible: root.active
                    text: "pause_circle"
                    color: parent.timerColor
                    font.pixelSize: Config.style.fontSizeNormal
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.pause()
                    }
                }

                Icon {
                    visible: root.active
                    text: "delete"
                    color: parent.timerColor
                    font.pixelSize: Config.style.fontSizeNormal
                    MouseArea {
                        anchors.fill: parent
                        onClicked: modelData.clear()
                    }
                }
            }
        }
    }
}
