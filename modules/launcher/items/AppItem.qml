import "../services"
import qs.Components
import qs.Services
import qs.Config
import Quickshell
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property DesktopEntry modelData
    required property PersistentProperties visibilities

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Config.style.roundingFull

        function onClicked(): void {
            Apps.launch(root.modelData);
            root.visibilities.launcher = false;
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Config.style.paddingLarger
        anchors.rightMargin: Config.style.paddingLarger
        anchors.margins: Config.style.paddingSmaller

        IconImage {
            id: icon

            source: Quickshell.iconPath(root.modelData?.icon, "image-missing")
            implicitSize: parent.height * 0.8

            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            anchors.left: icon.right
            anchors.leftMargin: Config.style.spacingNormal
            anchors.verticalCenter: icon.verticalCenter

            implicitWidth: parent.width - icon.width
            implicitHeight: name.implicitHeight + comment.implicitHeight

            StyledText {
                id: name

                text: root.modelData?.name ?? ""
                font.pixelSize: Config.style.fontSizeSmaller
            }

            StyledText {
                id: comment

                text: (root.modelData?.comment || root.modelData?.genericName || root.modelData?.name) ?? ""
                font.pixelSize: Config.style.fontSizeSmall
                color: Config.colours.alpha(Config.colours.accentPrimary, true)

                elide: Text.ElideRight
                width: root.width - icon.width - Config.style.roundingNormal * 2

                anchors.top: name.bottom
            }
        }
    }
}
