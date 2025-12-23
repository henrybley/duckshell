pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects

Variants {
    model: Quickshell.screens

    Scope {
        id: scope

        required property ShellScreen modelData

        Exclusions {
            screen: scope.modelData
        }

        StyledWindow {
            id: win

            screen: scope.modelData
            name: "drawers"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.launcher || visibilities.session ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

            mask: Region {
                x: Config.style.borderThickness
                y: Config.style.borderThickness
                width: win.width - Config.style.borderThickness
                height: win.height - Config.style.borderThickness * 2
                intersection: Intersection.Xor

                regions: regions.instances
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Variants {
                id: regions

                model: panels.children

                Region {
                    required property Item modelData

                    x: modelData.x
                    y: modelData.y + Config.style.borderThickness
                    width: modelData.width
                    height: modelData.height
                    intersection: Intersection.Subtract
                }
            }

            HyprlandFocusGrab {
                active: (visibilities.launcher && Config.launcher.enabled) || (visibilities.session && Config.session.enabled)
                windows: [win]
                onCleared: {
                    visibilities.launcher = false;
                    visibilities.session = false;
                }
            }

            /*StyledRect {
                anchors.fill: parent
                opacity: visibilities.session && Config.session.enabled ? 0.5 : 0
                color: Colours.palette.m3scrim

                Behavior on opacity {
                    NumberAnimation {
                        duration: Config.animation.animDurations.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Config.animation.animCurves.standard
                    }
                }
            }*/

            Item {
                anchors.fill: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    blurMax: 15
                    //shadowColor: Qt.alpha(Colours.palette.m3shadow, 0.7)
                }

                Border {}

                /*Backgrounds {
                    panels: panels
                }*/
            }

            PersistentProperties {
                id: visibilities

                property bool audio
                property bool session
                property bool launcher
                property bool dashboard
                property bool utilities

                Component.onCompleted: Visibilities.load(scope.modelData, this)
            }

            Interactions {
                screen: scope.modelData
                visibilities: visibilities
                panels: panels

                Panels {
                    id: panels

                    screen: scope.modelData
                    visibilities: visibilities
                }
            }
        }
    }
}
