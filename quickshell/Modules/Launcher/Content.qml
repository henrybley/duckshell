pragma ComponentBehavior: Bound

import "services"
import qs.Components
import qs.Services
import qs.Config
import Quickshell
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities
    readonly property int padding: Config.style.paddingLarge
    readonly property int rounding: Config.style.roundingLarge

    implicitWidth: listWrapper.width + padding * 2
    implicitHeight: searchWrapper.height + listWrapper.height + padding * 2

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Item {
        id: listWrapper

        implicitWidth: list.width
        implicitHeight: list.height + root.padding

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: searchWrapper.top
        anchors.bottomMargin: root.padding

        ContentList {
            id: list

            visibilities: root.visibilities
            search: search
            padding: root.padding
            rounding: root.rounding
        }
    }

    StyledRect {
        id: searchWrapper

        color: Config.colours.alpha(Config.colours.backgroundPrimary, true)
        radius: Config.style.roundingFull

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: root.padding

        implicitHeight: Math.max(searchIcon.implicitHeight, search.implicitHeight, clearIcon.implicitHeight)

        Icon {
            id: searchIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.padding

            text: "search"
            color: Config.colours.backgroundLight
        }

        StyledTextField {
            id: search

            anchors.left: searchIcon.right
            anchors.right: clearIcon.left
            anchors.leftMargin: Config.style.spacingSmall
            anchors.rightMargin: Config.style.spacingSmall

            topPadding: Config.style.paddingLarger
            bottomPadding: Config.style.paddingLarger

            placeholderText: qsTr("Type \"%1\" for commands").arg(Config.launcher.actionPrefix)

            onAccepted: {
                const currentItem = list.currentList?.currentItem;
                if (currentItem) {
                    if (list.showWallpapers) {
                        if (Colours.scheme === "dynamic" && currentItem.modelData.path !== Wallpapers.actualCurrent)
                            Wallpapers.previewColourLock = true;
                        Wallpapers.setWallpaper(currentItem.modelData.path);
                        root.visibilities.launcher = false;
                    } else if (text.startsWith(Config.launcher.actionPrefix)) {
                        if (text.startsWith(`${Config.launcher.actionPrefix}calc `))
                            currentItem.onClicked();
                        else
                            currentItem.modelData.onClicked(list.currentList);
                    } else {
                        Apps.launch(currentItem.modelData);
                        root.visibilities.launcher = false;
                    }
                }
            }

            Keys.onUpPressed: list.currentList?.decrementCurrentIndex()
            Keys.onDownPressed: list.currentList?.incrementCurrentIndex()

            Keys.onEscapePressed: root.visibilities.launcher = false

            Connections {
                target: root.visibilities

                function onLauncherChanged(): void {
                    if (root.visibilities.launcher)
                        search.focus = true;
                    else {
                        search.text = "";
                        const current = list.currentList;
                        if (current)
                            current.currentIndex = 0;
                    }
                }

                function onSessionChanged(): void {
                    if (root.visibilities.launcher && !root.visibilities.session)
                        search.focus = true;
                }
            }
        }

        Icon {
            id: clearIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: root.padding

            width: search.text ? implicitWidth : implicitWidth / 2
            opacity: {
                if (!search.text)
                    return 0;
                if (mouse.pressed)
                    return 0.7;
                if (mouse.containsMouse)
                    return 0.8;
                return 1;
            }

            text: "close"
            color: Config.colours.backgroundLight

            MouseArea {
                id: mouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: search.text ? Qt.PointingHandCursor : undefined

                onClicked: search.text = ""
            }

            Behavior on width {
                NumberAnimation {
                    duration: Config.animation.animDurations.small
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Config.animation.animCurves.standard
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Config.animation.animDurations.small
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Config.animation.animCurves.standard
                }
            }
        }
    }
}
