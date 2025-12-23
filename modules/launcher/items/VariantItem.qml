import "../services"
import qs.Components
import qs.Services
import qs.Config
import QtQuick

Item {
    id: root

    required property M3Variants.Variant modelData
    required property var list

    implicitHeight: Config.launcher.sizes.itemHeight

    anchors.left: parent?.left
    anchors.right: parent?.right

    StateLayer {
        radius: Config.style.roundingFull

        function onClicked(): void {
            root.modelData?.onClicked(root.list);
        }
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: Config.style.paddingLarger
        anchors.rightMargin: Config.style.paddingLarger
        anchors.margins: Config.style.paddingSmaller

        Icon {
            id: icon

            text: root.modelData?.icon ?? ""
            font.pixelSize: Config.style.fontSizeLarge//.extraLarge

            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            anchors.left: icon.right
            anchors.leftMargin: Config.style.spacingLarger
            anchors.verticalCenter: icon.verticalCenter

            implicitWidth: parent.width - icon.width
            implicitHeight: name.implicitHeight + desc.implicitHeight

            StyledText {
                id: name

                text: root.modelData?.name ?? ""
                font.pixelSize: Config.style.fontSizeNormal
            }

            StyledText {
                id: desc

                text: root.modelData?.description ?? ""
                font.pixelSize: Config.style.fontSizeSmall
                color: Config.colours.alpha(Config.colours.accentPrimary, true)

                elide: Text.ElideRight
                width: root.width - icon.width - Config.style.roundingNormal * 2

                anchors.top: name.bottom
            }
        }
    }
}
