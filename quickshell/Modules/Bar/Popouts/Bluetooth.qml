pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import qs.utils
import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property Item wrapper

    spacing: Config.style.spacingSmall

    StyledText {
        Layout.topMargin: Config.style.paddingNormal
        Layout.rightMargin: Config.style.paddingSmall
        text: qsTr("Bluetooth %1").arg(BluetoothAdapterState.toString(Bluetooth.defaultAdapter?.state).toLowerCase())
        font.weight: 500
    }

    Toggle {
        label: qsTr("Enabled")
        checked: Bluetooth.defaultAdapter?.enabled ?? false
        toggle.onToggled: {
            const adapter = Bluetooth.defaultAdapter;
            if (adapter)
                adapter.enabled = checked;
        }
    }

    Toggle {
        label: qsTr("Discovering")
        checked: Bluetooth.defaultAdapter?.discovering ?? false
        toggle.onToggled: {
            const adapter = Bluetooth.defaultAdapter;
            if (adapter)
                adapter.discovering = checked;
        }
    }

    StyledText {
        Layout.topMargin: Config.style.spacingSmall
        Layout.rightMargin: Config.style.paddingSmall
        text: {
            const devices = Bluetooth.devices.values;
            let available = qsTr("%1 device%2 available").arg(devices.length).arg(devices.length === 1 ? "" : "s");
            const connected = devices.filter(d => d.connected).length;
            if (connected > 0)
                available += qsTr(" (%1 connected)").arg(connected);
            return available;
        }
        color: Config.colours.backgroundLightVariant
        font.pixelSize: Config.style.fontSizeSmall
    }

    Repeater {
        model: ScriptModel {
            values: [...Bluetooth.devices.values].sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired)).slice(0, 5)
        }

        RowLayout {
            id: device

            required property BluetoothDevice modelData
            readonly property bool loading: modelData.state === BluetoothDeviceState.Connecting || modelData.state === BluetoothDeviceState.Disconnecting

            Layout.fillWidth: true
            Layout.rightMargin: Config.style.paddingSmall
            spacing: Config.style.spacingSmall

            opacity: 0
            scale: 0.7

            Component.onCompleted: {
                opacity = 1;
                scale = 1;
            }

            Behavior on opacity {
                Anim {}
            }

            Behavior on scale {
                Anim {}
            }

            Icon {
                text: Icons.getBluetoothIcon(device.modelData.icon)
            }

            StyledText {
                Layout.leftMargin: Config.style.spacingSmall / 2
                Layout.rightMargin: Config.style.spacingSmall / 2
                Layout.fillWidth: true
                text: device.modelData.name
            }

            StyledRect {
                id: connectBtn

                implicitWidth: implicitHeight
                implicitHeight: connectIcon.implicitHeight + Config.style.paddingSmall

                radius: Config.style.roundingFull
                color: device.modelData.state === BluetoothDeviceState.Connected ? Config.colours.textPrimary : Config.colours.backgroundPrimary

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
                    color: device.modelData.state === BluetoothDeviceState.Connected ? Config.colours.backgroundPrimary : Config.colours.backgroundLight
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
                    color: device.modelData.state === BluetoothDeviceState.Connected ? Config.colours.backgroundPrimary : Config.colours.backgroundLight

                    opacity: device.loading ? 0 : 1

                    Behavior on opacity {
                        Anim {}
                    }
                }
            }

            Loader {
                asynchronous: true
                active: device.modelData.bonded
                sourceComponent: Item {
                    implicitWidth: connectBtn.implicitWidth
                    implicitHeight: connectBtn.implicitHeight

                    StateLayer {
                        radius: Config.style.roundingFull

                        function onClicked(): void {
                            device.modelData.forget();
                        }
                    }

                    Icon {
                        anchors.centerIn: parent
                        text: "delete"
                    }
                }
            }
        }
    }

    StyledRect {
        Layout.topMargin: Config.style.spacingSmall
        implicitWidth: expandBtn.implicitWidth + Config.style.paddingNormal * 2
        implicitHeight: expandBtn.implicitHeight + Config.style.paddingSmall

        radius: Config.style.roundingNormal
        color: Config.colours.backgroundPrimary

        StateLayer {
            color: Config.colours.backgroundPrimaryContainer

            function onClicked(): void {
                root.wrapper.detach("bluetooth");
            }
        }

        RowLayout {
            id: expandBtn

            anchors.centerIn: parent
            spacing: Config.style.spacingSmall

            StyledText {
                Layout.leftMargin: Config.style.paddingSmaller
                text: qsTr("Open panel")
                color: Config.colours.backgroundPrimaryContainer
            }

            Icon {
                text: "chevron_right"
                color: Config.colours.backgroundPrimaryContainer
                font.pixelSize: Config.style.fontSizeLarge
            }
        }
    }

    component Toggle: RowLayout {
        required property string label
        property alias checked: toggle.checked
        property alias toggle: toggle

        Layout.fillWidth: true
        Layout.rightMargin: Config.style.paddingSmall
        spacing: Config.style.spacingNormal

        StyledText {
            Layout.fillWidth: true
            text: parent.label
        }

        StyledSwitch {
            id: toggle
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
