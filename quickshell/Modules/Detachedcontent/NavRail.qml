pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Session session
    property bool expanded

    implicitWidth: layout.implicitWidth + Config.style.paddingLarge * 4
    implicitHeight: layout.implicitHeight + Config.style.paddingLarge * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Config.style.spacingNormal

        states: State {
            name: "expanded"
            when: root.expanded

            PropertyChanges {
                layout.spacing: Config.style.spacingSmall
                menuIcon.opacity: 0
                menuIconExpanded.opacity: 1
                menuIcon.rotation: 180
                menuIconExpanded.rotation: 0
            }
            AnchorChanges {
                target: menuIcon
                anchors.horizontalCenter: undefined
            }
            AnchorChanges {
                target: menuIconExpanded
                anchors.horizontalCenter: undefined
            }
        }

        transitions: Transition {
            Anim {
                properties: "spacing,opacity,rotation"
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.bottomMargin: Config.style.spacingLarge * 2
            implicitHeight: Math.max(menuIcon.implicitHeight, menuIconExpanded.implicitHeight) + Config.style.paddingNormal * 2

            StateLayer {
                radius: Config.style.roundingSmall

                function onClicked(): void {
                    root.expanded = !root.expanded;
                }
            }

            Icon {
                id: menuIcon

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "menu"
                font.pixelSize: Config.style.fontSizeLarge
            }

            Icon {
                id: menuIconExpanded

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: "menu_open"
                font.pixelSize: Config.style.fontSizeLarge
                opacity: 0
                rotation: -180
            }
        }

        NavItem {
            icon: "network_manage"
            label: "network"
        }

        NavItem {
            icon: "settings_bluetooth"
            label: "bluetooth"
        }
    }

    component NavItem: Item {
        id: item

        required property string icon
        required property string label
        readonly property bool active: root.session.active === label

        implicitWidth: background.implicitWidth
        implicitHeight: background.implicitHeight + smallLabel.implicitHeight + smallLabel.anchors.topMargin

        states: State {
            name: "expanded"
            when: root.expanded

            PropertyChanges {
                expandedLabel.opacity: 1
                smallLabel.opacity: 0
                background.implicitWidth: Config.dcontent.sizes.expandedNavWidth
                background.implicitHeight: icon.implicitHeight + Config.style.paddingNormal * 2
                item.implicitHeight: background.implicitHeight
            }
        }

        transitions: Transition {
            Anim {
                property: "opacity"
                duration: Config.animation.animDurations.small
            }

            Anim {
                properties: "implicitWidth,implicitHeight"
                duration: Config.animation.animDurations.expressiveDefaultSpatial
                easing.bezierCurve: Config.animation.animCurves.expressiveDefaultSpatial
            }
        }

        StyledRect {
            id: background

            radius: Config.style.roundingFull
            color: item.active ? Colours.palette.m3secondaryContainer : Config.colours.backgroundLight

            implicitWidth: icon.implicitWidth + icon.anchors.leftMargin * 2
            implicitHeight: icon.implicitHeight + Config.style.paddingSmall

            StateLayer {
                color: item.active ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight

                function onClicked(): void {
                    root.session.active = item.label;
                }
            }

            Icon {
                id: icon

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Config.style.paddingLarge

                text: item.icon
                color: item.active ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeLarge
                fill: item.active ? 1 : 0

                Behavior on fill {
                    Anim {}
                }
            }

            StyledText {
                id: expandedLabel

                anchors.left: icon.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Config.style.spacingSmall

                opacity: 0
                text: item.label
                color: item.active ? Config.colours.backgroundLightContainer : Config.colours.backgroundLight
                font.capitalization: Font.Capitalize
            }

            StyledText {
                id: smallLabel

                anchors.horizontalCenter: icon.horizontalCenter
                anchors.top: icon.bottom
                anchors.topMargin: Config.style.spacingSmall / 2

                text: item.label
                font.pixelSize: Config.style.fontSizeSmall
                font.capitalization: Font.Capitalize
            }
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
