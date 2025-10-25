import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import qs.Modules.Bar.Modules
import qs.Config
import qs.Components
import qs.Services

Scope {
    id: rootScope
    property var shell

    Item {
        id: barRootItem
        anchors.fill: parent

        Variants {
            model: Quickshell.screens

            Item {
                property var modelData

                PanelWindow {
                    id: panel
                    screen: modelData
                    color: "transparent"
                    implicitHeight: barBackground.height
                    anchors.top: true
                    anchors.left: true
                    anchors.right: true
                    aboveWindows: true
                    WlrLayershell.exclusiveZone: 0
                    WlrLayershell.layer: WlrLayer.Overlay

                    WlrLayershell.namespace: "bar-" + screen.name


                    //todo: improve this to only render on one screen
                    //this still runs foreach screen so is inneficient
                    //visible: screen.name === "HDMI-A-1"

                    Rectangle {
                        id: barBackground
                        width: parent.width
                        height: 26
                        //color: "blue"
                        color: "transparent"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                    Component.onCompleted: {
                        console.log("Bar loaded on screen:", screen.name)
                    }


                    /*Row {
                        id: leftWidgetsRow
                        anchors.verticalCenter: barBackground.verticalCenter
                        anchors.left: barBackground.left
                        anchors.leftMargin: 18
                        spacing: 12

                        SystemInfo {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Media {
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }*/

                    /*ActiveWindow {
                        screen: modelData
                    }*/

                    /*Workspace {
                        id: workspace
                        screen: modelData
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.verticalCenter: barBackground.verticalCenter
                    }*/

                    Row {
                        id: rightWidgetsRow
                        anchors.verticalCenter: barBackground.verticalCenter
                        anchors.right: barBackground.right
                        spacing: 12

                        /*NotificationIcon {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Brightness {
                            id: widgetsBrightness
                            anchors.verticalCenter: parent.verticalCenter
                        }*/

                        /*Volume {
                            id: widgetsVolume
                            shell: rootScope.shell
                            anchors.verticalCenter: parent.verticalCenter
                        }*/

                        /*SystemTray {
                            id: systemTrayModule
                            shell: rootScope.shell
                            anchors.verticalCenter: parent.verticalCenter
                            bar: panel
                            trayMenu: externalTrayMenu
                        }

                        CustomTrayMenu {
                            id: externalTrayMenu
                        }*/

                        Clock {
                            screen: modelData
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        /*PanelPopup {
                            id: sidebarPopup
                        }

                        Button {
                            barBackground: barBackground
                            anchors.verticalCenter: parent.verticalCenter
                            screen: modelData
                            sidebarPopup: sidebarPopup
                        }*/
                    }

                    //Background {}
                    //Overview {}
                }

                /*PanelWindow {
                    id: topLeftPanel
                    anchors.top: true
                    anchors.left: true

                    color: "transparent"
                    screen: modelData
                    margins.top: 36
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Background
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"
                    implicitHeight: 24

                    Corners {
                        id: topLeftCorner
                        position: "bottomleft"
                        size: 1.3
                        fillColor: (Config.colours.backgroundPrimary !== undefined && Config.colours.backgroundPrimary !== null) ? Config.colours.backgroundPrimary : "#222"
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                PanelWindow {
                    id: topRightPanel
                    anchors.top: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData
                    margins.top: 36
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Background
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: topRightCorner
                        position: "bottomright"
                        size: 1.3
                        fillColor: (Config.colours.backgroundPrimary !== undefined && Config.colours.backgroundPrimary !== null) ? Config.colours.backgroundPrimary : "#222"
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                PanelWindow {
                    id: bottomLeftPanel
                    anchors.bottom: true
                    anchors.left: true
                    color: "transparent"
                    screen: modelData
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Background
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomLeftCorner
                        position: "topleft"
                        size: 1.3
                        fillColor: Config.colours.backgroundPrimary
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                PanelWindow {
                    id: bottomRightPanel
                    anchors.bottom: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Background
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomRightCorner
                        position: "topright"
                        size: 1.3
                        fillColor: Config.colours.backgroundPrimary
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }*/
            }
        }
    }

    // This alias exposes the visual bar's visibility to the outside world
    property alias visible: barRootItem.visible
}
