pragma ComponentBehavior: Bound

import ".."
import qs.Components
import qs.Services
import qs.Config
import qs.Utils
import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root

    required property Session session

    anchors.fill: parent
    spacing: Config.style.spacingSmall

    StyledText {
        text: qsTr("Settings")
        font.pixelSize: Config.style.fontSizeLarge
        font.weight: 500
    }

    StyledText {
        text: qsTr("General bluetooth settings")
        color: Colours.palette.m3outline
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: settingsText.implicitHeight + Config.style.paddingNormal * 2

        radius: Config.style.roundingNormal
        color: Config.colours.backgroundLight

        StateLayer {
            function onClicked(): void {
                root.session.bt.active = null;
            }
        }

        StyledText {
            id: settingsText

            anchors.centerIn: parent
            text: qsTr("Bluetooth settings")
        }
    }

    RowLayout {
        Layout.topMargin: Config.style.spacingLarge
        Layout.fillWidth: true
        spacing: Config.style.spacingNormal

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Config.style.spacingSmall

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Devices (%1)").arg(Bluetooth.devices.values.length)
                font.pixelSize: Config.style.fontSizeLarge
                font.weight: 500
            }

            StyledText {
                Layout.fillWidth: true
                text: qsTr("All available bluetooth devices")
                color: Colours.palette.m3outline
            }
        }

        StyledRect {
            implicitWidth: implicitHeight
            implicitHeight: scanIcon.implicitHeight + Config.style.paddingNormal * 2

            radius: Bluetooth.defaultAdapter?.discovering ? Config.style.roundingNormal : implicitHeight / 2
            color: Bluetooth.defaultAdapter?.discovering ? Colours.palette.m3secondary : Colours.palette.m3secondaryContainer

            StateLayer {
                color: Bluetooth.defaultAdapter?.discovering ? Config.colours.backgroundLight : Config.colours.backgroundLightContainer

                function onClicked(): void {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter)
                        adapter.discovering = !adapter.discovering;
                }
            }

            Icon {
                id: scanIcon

                anchors.centerIn: parent
                animate: true
                text: "bluetooth_searching"
                color: Bluetooth.defaultAdapter?.discovering ? Config.colours.backgroundLight : Config.colours.backgroundLightContainer
                fill: Bluetooth.defaultAdapter?.discovering ? 1 : 0
            }

            Behavior on radius {
                Anim {}
            }
        }
    }

    StyledListView {
        model: ScriptModel {
            values: [...Bluetooth.devices.values].sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired))
        }

        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        ScrollBar.vertical: StyledScrollBar {}

        delegate: Item {
            id: device

            required property BluetoothDevice modelData
            readonly property bool loading: modelData.state === BluetoothDeviceState.Connecting || modelData.state === BluetoothDeviceState.Disconnecting
            readonly property bool connected: modelData.state === BluetoothDeviceState.Connected

            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: deviceInner.implicitHeight + Config.style.paddingNormal * 2

            StateLayer {
                id: stateLayer

                radius: Config.style.roundingSmall

                function onClicked(): void {
                    root.session.bt.active = device.modelData;
                }
            }

            RowLayout {
                id: deviceInner

                anchors.fill: parent
                anchors.margins: Config.style.paddingNormal

                spacing: Config.style.spacingNormal

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: icon.implicitHeight + Config.style.paddingNormal * 2

                    radius: Config.style.roundingNormal
                    color: device.connected ? Config.colours.backgroundPrimary : device.modelData.bonded ? Colours.palette.m3secondaryContainer : Config.colours.backgroundLightHigh

                    StyledRect {
                        anchors.fill: parent
                        radius: parent.radius
                        color: Qt.alpha(device.connected ? Config.colours.backgroundPrimary : device.modelData.bonded ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight, stateLayer.pressed ? 0.1 : stateLayer.containsMouse ? 0.08 : 0)
                    }

                    Icon {
                        id: icon

                        anchors.centerIn: parent
                        text: Icons.getBluetoothIcon(device.modelData.icon)
                        color: device.connected ? Config.colours.backgroundPrimary : device.modelData.bonded ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight
                        font.pixelSize: Config.style.fontSizeLarge
                        fill: device.connected ? 1 : 0

                        Behavior on fill {
                            Anim {}
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    spacing: 0

                    StyledText {
                        Layout.fillWidth: true
                        text: device.modelData.name
                        elide: Text.ElideRight
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: device.modelData.address + (device.connected ? qsTr(" (Connected)") : device.modelData.bonded ? qsTr(" (Paired)") : "")
                        color: Colours.palette.m3outline
                        font.pixelSize: Config.style.fontSizeSmall
                        elide: Text.ElideRight
                    }
                }

                StyledRect {
                    id: connectBtn

                    implicitWidth: implicitHeight
                    implicitHeight: connectIcon.implicitHeight + Config.style.paddingSmall * 2

                    radius: Config.style.roundingFull
                    color: device.connected ? Config.colours.backgroundPrimary : "transparent"

                    StyledBusyIndicator {
                        anchors.centerIn: parent

                        implicitWidth: implicitHeight
                        implicitHeight: connectIcon.implicitHeight

                        running: opacity > 0
                        opacity: device.loading ? 1 : 0

                        Behavior on opacity {
                            Anim {}
                        }
                    }

                    StateLayer {
                        color: device.connected ? Config.colours.backgroundPrimary : Config.colours.backgroundLight
                        disabled: device.loading

                        function onClicked(): void {
                            device.modelData.connected = !device.modelData.connected;
                        }
                    }

                    Icon {
                        id: connectIcon

                        anchors.centerIn: parent
                        animate: true
                        text: device.modelData.connected ? "link_off" : "link"
                        color: device.connected ? Config.colours.backgroundPrimary : Config.colours.backgroundLight

                        opacity: device.loading ? 0 : 1

                        Behavior on opacity {
                            Anim {}
                        }
                    }
                }
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
