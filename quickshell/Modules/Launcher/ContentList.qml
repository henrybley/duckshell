pragma ComponentBehavior: Bound

import qs.Components
import qs.Services
import qs.Config
import qs.Utils
import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    id: root

    required property PersistentProperties visibilities
    required property TextField search
    required property int padding
    required property int rounding

    readonly property bool showWallpapers: search.text.startsWith(`${Config.launcher.actionPrefix}wallpaper `)
    readonly property Item currentList: showWallpapers ? wallpaperList.item : appList.item

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    clip: true
    state: showWallpapers ? "wallpapers" : "apps"

    states: [
        State {
            name: "apps"

            PropertyChanges {
                root.implicitWidth: Config.launcher.sizes.itemWidth
                root.implicitHeight: appList.implicitHeight > 0 ? appList.implicitHeight : empty.implicitHeight
                appList.active: true
            }

            AnchorChanges {
                anchors.left: root.parent.left
                anchors.right: root.parent.right
            }
        },
        State {
            name: "wallpapers"

            PropertyChanges {
                root.implicitWidth: Math.max(Config.launcher.sizes.itemWidth * 1.2, wallpaperList.implicitWidth)
                root.implicitHeight: Config.launcher.sizes.wallpaperHeight
                wallpaperList.active: true
            }
        }
    ]

    Behavior on state {
        SequentialAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                from: 1
                to: 0
                duration: Config.animation.animDurations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
            PropertyAction {}
            NumberAnimation {
                target: root
                property: "opacity"
                from: 0
                to: 1
                duration: Config.animation.animDurations.small
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Config.animation.animCurves.standard
            }
        }
    }

    Loader {
        id: appList

        active: false
        asynchronous: true

        anchors.left: parent.left
        anchors.right: parent.right

        sourceComponent: AppList {
            search: root.search
            visibilities: root.visibilities
        }
    }

    /*Loader {
        id: wallpaperList

        active: false
        asynchronous: true

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: WallpaperList {
            search: root.search
            visibilities: root.visibilities
        }
    }*/

    Row {
        id: empty

        opacity: root.currentList?.count === 0 ? 1 : 0
        scale: root.currentList?.count === 0 ? 1 : 0.5

        spacing: Config.style.spacingNormal
        padding: Config.style.paddingLarge

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Icon {
            text: root.state === "wallpapers" ? "wallpaper_slideshow" : "manage_search"
            color: Config.colours.backgroundLight
            font.pixelSize: Config.style.fontSizeNormal

            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter

            StyledText {
                text: root.state === "wallpapers" ? qsTr("No wallpapers found") : qsTr("No results")
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeNormal
            }

            StyledText {
                text: root.state === "wallpapers" && Wallpapers.list.length === 0 ? qsTr("Try putting some wallpapers in %1").arg(Paths.shortenHome(Config.paths.wallpaperDir)) : qsTr("Try searching for something else")
                color: Config.colours.backgroundLight
                font.pixelSize: Config.style.fontSizeNormal
            }
        }

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
    }

    Behavior on implicitWidth {
        enabled: root.visibilities.launcher

        NumberAnimation {
            duration: Config.animation.animDurations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.emphasizedDecel
        }
    }

    Behavior on implicitHeight {
        enabled: root.visibilities.launcher

        NumberAnimation {
            duration: Config.animation.animDurations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Config.animation.animCurves.emphasizedDecel
        }
    }
}
