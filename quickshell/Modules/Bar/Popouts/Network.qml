pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.config
import qs.utils
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    property string connectingToSsid: ""

    spacing: Config.style.spacingSmall
    width: Config.bar.sizes.networkWidth

    StyledText {
        Layout.topMargin: Config.style.paddingNormal
        Layout.rightMargin: Config.style.paddingSmall
        text: qsTr("Wifi %1").arg(Network.wifiEnabled ? "enabled" : "disabled")
        font.weight: 500
    }

    Toggle {
        label: qsTr("Enabled")
        checked: Network.wifiEnabled
        toggle.onToggled: Network.enableWifi(checked)
    }

    StyledText {
        Layout.topMargin: Config.style.spacingSmall
        Layout.rightMargin: Config.style.paddingSmall
        text: qsTr("%1 networks available").arg(Network.networks.length)
        color: Config.colours.backgroundLightVariant
        font.pixelSize: Config.style.fontSizeSmall
    }

    Repeater {
        model: ScriptModel {
            values: [...Network.networks].sort((a, b) => {
                if (a.active !== b.active)
                    return b.active - a.active;
                return b.strength - a.strength;
            }).slice(0, 8)
        }

        RowLayout {
            id: networkItem

            required property var modelData
            readonly property bool isConnecting: root.connectingToSsid === modelData.ssid
            readonly property bool loading: networkItem.isConnecting

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
                text: Icons.getNetworkIcon(networkItem.modelData.strength)
                color: networkItem.modelData.active ? Config.colours.textPrimary : Config.colours.backgroundLightVariant
            }

            Icon {
                visible: networkItem.modelData.isSecure
                text: "lock"
                font.pixelSize: Config.style.fontSizeSmall
            }

            StyledText {
                Layout.leftMargin: Config.style.spacingSmall / 2
                Layout.rightMargin: Config.style.spacingSmall / 2
                Layout.fillWidth: true
                text: networkItem.modelData.ssid
                elide: Text.ElideRight
                font.weight: networkItem.modelData.active ? 500 : 400
                color: networkItem.modelData.active ? Config.colours.textPrimary : Config.colours.backgroundLight
            }

            StyledRect {
                id: connectBtn

                implicitWidth: implicitHeight
                implicitHeight: connectIcon.implicitHeight + Config.style.paddingSmall

                radius: Config.style.roundingFull
                color: networkItem.modelData.active ? Config.colours.textPrimary : Config.colours.backgroundPrimary

                StyledBusyIndicator {
                    anchors.centerIn: parent

                    implicitWidth: implicitHeight
                    implicitHeight: connectIcon.implicitHeight

                    running: opacity > 0
                    opacity: networkItem.loading ? 1 : 0

                    Behavior on opacity {
                        Anim {}
                    }
                }

                StateLayer {
                    color: networkItem.modelData.active ? Config.colours.backgroundPrimary : Config.colours.backgroundLight
                    disabled: networkItem.loading || !Network.wifiEnabled

                    function onClicked(): void {
                        if (networkItem.modelData.active) {
                            Network.disconnectFromNetwork();
                        } else {
                            root.connectingToSsid = networkItem.modelData.ssid;
                            Network.connectToNetwork(networkItem.modelData.ssid, "");
                        }
                    }
                }

                Icon {
                    id: connectIcon

                    anchors.centerIn: parent
                    animate: true
                    text: networkItem.modelData.active ? "link_off" : "link"
                    color: networkItem.modelData.active ? Config.colours.backgroundPrimary : Config.colours.backgroundLight

                    opacity: networkItem.loading ? 0 : 1

                    Behavior on opacity {
                        Anim {}
                    }
                }
            }
        }
    }

    StyledRect {
        Layout.topMargin: Config.style.spacingSmall
        Layout.fillWidth: true
        implicitHeight: rescanBtn.implicitHeight + Config.style.paddingSmall * 2

        radius: Config.style.roundingNormal
        color: Network.scanning ? Config.colours.backgroundLight : Config.colours.backgroundPrimary

        StateLayer {
            color: Network.scanning ? Config.colours.backgroundLight : Config.colours.backgroundPrimary
            disabled: Network.scanning || !Network.wifiEnabled

            function onClicked(): void {
                Network.rescanWifi();
            }
        }

        RowLayout {
            id: rescanBtn
            anchors.centerIn: parent
            spacing: Config.style.spacingSmall

            Icon {
                id: scanIcon

                animate: true
                text: Network.scanning ? "refresh" : "wifi_find"
                color: Network.scanning ? Config.colours.backgroundLight : Config.colours.backgroundPrimary

                RotationAnimation on rotation {
                    running: Network.scanning
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 1000
                }
            }

            StyledText {
                text: Network.scanning ? qsTr("Scanning...") : qsTr("Rescan networks")
                color: Network.scanning ? Config.colours.backgroundLight : Config.colours.backgroundPrimary
            }
        }
    }

    // Reset connecting state when network changes
    Connections {
        target: Network

        function onActiveChanged(): void {
            if (Network.active && root.connectingToSsid === Network.active.ssid) {
                root.connectingToSsid = "";
            }
        }

        function onScanningChanged(): void {
            if (!Network.scanning)
                scanIcon.rotation = 0;
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
