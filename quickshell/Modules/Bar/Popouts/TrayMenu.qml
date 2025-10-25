pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls

StackView {
    id: root

    required property Item popouts
    required property QsMenuHandle trayItem

    implicitWidth: currentItem.implicitWidth
    implicitHeight: currentItem.implicitHeight

    initialItem: SubMenu {
        handle: root.trayItem
    }

    pushEnter: Anim {}
    pushExit: Anim {}
    popEnter: Anim {}
    popExit: Anim {}

    HyprlandFocusGrab {
        active: true
        windows: [QsWindow.window]
        onCleared: root.popouts.hasCurrent = false
    }

    component Anim: Transition {
        NumberAnimation {
            duration: 0
        }
    }

    component SubMenu: Column {
        id: menu

        required property QsMenuHandle handle
        property bool isSubMenu
        property bool shown

        padding: Config.style.paddingSmaller
        spacing: Config.style.spacingSmall

        opacity: shown ? 1 : 0
        scale: shown ? 1 : 0.8

        Component.onCompleted: shown = true
        StackView.onActivating: shown = true
        StackView.onDeactivating: shown = false
        StackView.onRemoved: destroy()

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: Config.animation.animDurations.normal
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }

        QsMenuOpener {
            id: menuOpener

            menu: menu.handle
        }

        Repeater {
            model: menuOpener.children

            StyledRect {
                id: item

                required property QsMenuEntry modelData

                implicitWidth: Config.bar.sizes.trayMenuWidth
                implicitHeight: modelData.isSeparator ? 1 : children.implicitHeight

                radius: Config.style.roundingFull
                color: modelData.isSeparator ? Colours.palette.m3outlineVariant : "transparent"

                Loader {
                    id: children

                    anchors.left: parent.left
                    anchors.right: parent.right

                    active: !item.modelData.isSeparator
                    asynchronous: true

                    sourceComponent: Item {
                        implicitHeight: label.implicitHeight

                        StateLayer {
                            anchors.margins: -Config.style.paddingSmall / 2
                            anchors.leftMargin: -Config.style.paddingSmaller
                            anchors.rightMargin: -Config.style.paddingSmaller

                            radius: item.radius
                            disabled: !item.modelData.enabled

                            function onClicked(): void {
                                const entry = item.modelData;
                                if (entry.hasChildren)
                                    root.push(subMenuComp.createObject(null, {
                                        handle: entry,
                                        isSubMenu: true
                                    }));
                                else {
                                    item.modelData.triggered();
                                    root.popouts.hasCurrent = false;
                                }
                            }
                        }

                        Loader {
                            id: icon

                            anchors.left: parent.left

                            active: item.modelData.icon !== ""
                            asynchronous: true

                            sourceComponent: IconImage {
                                implicitSize: label.implicitHeight

                                source: item.modelData.icon
                            }
                        }

                        StyledText {
                            id: label

                            anchors.left: icon.right
                            anchors.leftMargin: icon.active ? Config.style.spacingSmaller : 0

                            text: labelMetrics.elidedText
                            color: item.modelData.enabled ? Config.colours.backgroundLight : Colours.palette.m3outline
                        }

                        TextMetrics {
                            id: labelMetrics

                            text: item.modelData.text
                            font.pixelSize: label.font.pixelSize
                            font.family: label.font.family

                            elide: Text.ElideRight
                            elideWidth: Config.bar.sizes.trayMenuWidth - (icon.active ? icon.implicitWidth + label.anchors.leftMargin : 0) - (expand.active ? expand.implicitWidth + Config.style.spacingNormal : 0)
                        }

                        Loader {
                            id: expand

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            active: item.modelData.hasChildren
                            asynchronous: true

                            sourceComponent: Icon {
                                text: "chevron_right"
                                color: item.modelData.enabled ? Config.colours.backgroundLight : Colours.palette.m3outline
                            }
                        }
                    }
                }
            }
        }

        Loader {
            active: menu.isSubMenu
            asynchronous: true

            sourceComponent: Item {
                implicitWidth: back.implicitWidth
                implicitHeight: back.implicitHeight + Config.style.spacingSmall / 2

                Item {
                    anchors.bottom: parent.bottom
                    implicitWidth: back.implicitWidth
                    implicitHeight: back.implicitHeight

                    StyledRect {
                        anchors.fill: parent
                        anchors.margins: -Config.style.paddingSmall / 2
                        anchors.leftMargin: -Config.style.paddingSmaller
                        anchors.rightMargin: -Config.style.paddingSmaller * 2

                        radius: Config.style.roundingFull
                        color: Colours.palette.m3secondaryContainer

                        StateLayer {
                            radius: parent.radius
                            color: Config.colours.backgroundLightContainer

                            function onClicked(): void {
                                root.pop();
                            }
                        }
                    }

                    Row {
                        id: back

                        anchors.verticalCenter: parent.verticalCenter

                        Icon {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "chevron_left"
                            color: Config.colours.backgroundLightContainer
                        }

                        StyledText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Back")
                            color: Config.colours.backgroundLightContainer
                        }
                    }
                }
            }
        }
    }

    Component {
        id: subMenuComp

        SubMenu {}
    }
}
