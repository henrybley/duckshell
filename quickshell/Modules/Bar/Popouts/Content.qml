pragma ComponentBehavior: Bound

import qs.Config
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Item {
    id: root

    required property Item wrapper

    anchors.centerIn: parent

    implicitWidth: (content.children.find(c => c.shouldBeActive)?.implicitWidth ?? 0) + Config.style.paddingLarge * 2
    implicitHeight: (content.children.find(c => c.shouldBeActive)?.implicitHeight ?? 0) + Config.style.paddingLarge * 2

    Item {
        id: content

        anchors.fill: parent
        anchors.margins: Config.style.paddingLarge

        /*Popout {
            name: "activewindow"
            sourceComponent: ActiveWindow {
                wrapper: root.wrapper
            }
        }*/

        /*Popout {
            name: "network"
            source: "Network.qml"
        }

        Popout {
            name: "bluetooth"
            sourceComponent: Bluetooth {
                wrapper: root.wrapper
            }
        }

        Popout {
            name: "battery"
            source: "Battery.qml"
        }*/

        /*Popout {
            name: "audio"
            sourceComponent: Audio {
                wrapper: root.wrapper
            }
        }*/
        
        /*Popout {
            name: "workspace"
            sourceComponent: Workspace {
                id: workspace
                screen: modelData
                anchors.horizontalCenter: barBackground.horizontalCenter
                anchors.verticalCenter: barBackground.verticalCenter
            }        
        }*/

        /*Repeater {
            model: ScriptModel {
                values: [...SystemTray.items.values]
            }

            Popout {
                id: trayMenu

                required property SystemTrayItem modelData
                required property int index

                name: `traymenu${index}`
                sourceComponent: trayMenuComp

                Connections {
                    target: root.wrapper

                    function onHasCurrentChanged(): void {
                        if (root.wrapper.hasCurrent && trayMenu.shouldBeActive) {
                            trayMenu.sourceComponent = null;
                            trayMenu.sourceComponent = trayMenuComp;
                        }
                    }
                }

                Component {
                    id: trayMenuComp

                    TrayMenu {
                        popouts: root.wrapper
                        trayItem: trayMenu.modelData.menu
                    }
                }
            }
        }*/
    }

    component Popout: Loader {
        id: popout

        required property string name
        property bool shouldBeActive: root.wrapper.currentName === name

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        opacity: 0
        scale: 0.8
        active: false
        asynchronous: true

        states: State {
            name: "active"
            when: popout.shouldBeActive

            PropertyChanges {
                popout.active: true
                popout.opacity: 1
                popout.scale: 1
            }
        }

        transitions: [
            Transition {
                from: "active"
                to: ""

                SequentialAnimation {
                    Anim {
                        properties: "opacity,scale"
                        duration: Config.animation.animDurations.small
                    }
                    PropertyAction {
                        target: popout
                        property: "active"
                    }
                }
            },
            Transition {
                from: ""
                to: "active"

                SequentialAnimation {
                    PropertyAction {
                        target: popout
                        property: "active"
                    }
                    Anim {
                        properties: "opacity,scale"
                    }
                }
            }
        ]
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
