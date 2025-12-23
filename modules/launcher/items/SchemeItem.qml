import "../services"
import qs.Components
import qs.Services
import qs.Config
import QtQuick

Item {
    id: root

    required property Schemes.Scheme modelData
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

        StyledRect {
            id: preview

            anchors.verticalCenter: parent.verticalCenter

            border.width: 1
            border.color: Qt.alpha(`#${root.modelData?.colours?.outline}`, 0.5)

            color: `#${root.modelData?.colours?.surface}`
            radius: Config.style.roundingFull
            implicitWidth: parent.height * 0.8
            implicitHeight: parent.height * 0.8

            Item {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                implicitWidth: parent.implicitWidth / 2
                clip: true

                StyledRect {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    implicitWidth: preview.implicitWidth
                    color: `#${root.modelData?.colours?.primary}`
                    radius: Config.style.roundingFull
                }
            }
        }

        Column {
            anchors.left: preview.right
            anchors.leftMargin: Config.style.spacingNormal
            anchors.verticalCenter: parent.verticalCenter

            width: parent.width - preview.width
            spacing: 0

            StyledText {
                id: name

                text: root.modelData?.name ?? ""
                font.pixelSize: Config.style.fontSizeNormal
            }

            StyledText {
                id: comment

                text: root.modelData?.flavour ?? ""
                font.pixelSize: Config.style.fontSizeSmall
                color: Config.colours.accentPrimary

                elide: Text.ElideRight
                width: parent.width - Config.style.roundingNormal * 2
            }
        }
    }
}
