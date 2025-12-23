import qs.Components
import qs.Services
import qs.Config
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var list
    readonly property string math: list.search.text.slice(`${Config.launcher.actionPrefix}calc `.length)

    function onClicked(): void {
        Quickshell.execDetached(["sh", "-c", `qalc -t -m 100 '${root.math}' | wl-copy`]);
        root.list.visibilities.launcher = false;
    }

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    onMathChanged: {
        if (math) {
            qalcProc.command = ["qalc", "-m", "100", math];
            qalcProc.running = true;
        }
    }

    StateLayer {
        radius: Config.style.roundingFull

        function onClicked(): void {
            root.onClicked();
        }
    }

    Binding {
        id: binding

        when: root.math.length > 0
        target: metrics
        property: "text"
    }

    Process {
        id: qalcProc

        stdout: StdioCollector {
            onStreamFinished: binding.value = text.trim()
        }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: Config.style.paddingLarger

        spacing: Config.style.spacingNormal

        Icon {
            text: "function"
            font.pixelSize: Config.style.fontSizeLarge
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            id: result

            color: {
                if (metrics.text.includes("error: "))
                    return Config.colours.error;
                if (!root.math)
                    return Config.colours.backgroundLight;
                return Config.colours.backgroundPrimary;
            }

            text: metrics.elidedText
            font.pixelSize: Config.style.fontSizeNormal

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            TextMetrics {
                id: metrics

                text: qsTr("Type an expression to calculate")
                font.family: result.font.family
                font.pixelSize: result.font.pixelSize
                elide: Text.ElideRight
                elideWidth: result.width
            }
        }

        StyledRect {
            color: Config.colors.textSecondary
            radius: Config.style.roundingNormal
            clip: true

            implicitWidth: (stateLayer.containsMouse ? label.implicitWidth + label.anchors.rightMargin : 0) + icon.implicitWidth + Config.style.paddingNormal * 2
            implicitHeight: Math.max(label.implicitHeight, icon.implicitHeight) + Config.style.paddingSmall * 2

            Layout.alignment: Qt.AlignVCenter

            StateLayer {
                id: stateLayer

                color: Config.colours.textSecondary

                function onClicked(): void {
                    Quickshell.execDetached(["app2unit", "--", "foot", "fish", "-C", `exec qalc -i '${root.math}'`]);
                    root.list.visibilities.launcher = false;
                }
            }

            StyledText {
                id: label

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: icon.left
                anchors.rightMargin: Config.style.spacingSmall

                text: qsTr("Open in calculator")
                color: Config.colours.textSecondary
                font.pixelSize: Config.style.fontSizeNormal

                opacity: stateLayer.containsMouse ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animation.animDurations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                }
            }

            Icon {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Config.style.paddingNormal

                text: "open_in_new"
                color: Config.colours.textSecondary
                font.pixelSize: Config.style.fontSizeLarge
            }

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: Config.animation.animDurations.normal
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Config.animation.animCurves.emphasized
                }
            }
        }
    }
}
