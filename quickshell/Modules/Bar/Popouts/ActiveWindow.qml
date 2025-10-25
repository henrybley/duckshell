import qs.Components
import qs.Services
//import qs.utils
import qs.Config
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Item wrapper

    implicitWidth: Hyprland.activeToplevel ? child.implicitWidth : -Config.style.paddingLarge * 2
    implicitHeight: child.implicitHeight

    Column {
        id: child

        anchors.centerIn: parent
        spacing: Config.style.spacingNormal

        RowLayout {
            id: detailsRow

            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Config.style.spacingNormal

            IconImage {
                id: icon

                Layout.alignment: Qt.AlignVCenter
                implicitSize: details.implicitHeight
                source: Icons.getAppIcon(Hyprland.activeToplevel?.lastIpcObject.class ?? "", "image-missing")
            }

            ColumnLayout {
                id: details

                spacing: 0
                Layout.fillWidth: true

                StyledText {
                    Layout.fillWidth: true
                    text: Hyprland.activeToplevel?.title ?? ""
                    font.pixelSize: Config.style.fontSizeNormal
                    elide: Text.ElideRight
                }

                StyledText {
                    Layout.fillWidth: true
                    text: Hyprland.activeToplevel?.lastIpcObject.class ?? ""
                    color: Config.colours.backgroundLightVariant
                    elide: Text.ElideRight
                }
            }

            Item {
                implicitWidth: expandIcon.implicitHeight + Config.style.paddingSmall * 2
                implicitHeight: expandIcon.implicitHeight + Config.style.paddingSmall * 2

                Layout.alignment: Qt.AlignVCenter

                StateLayer {
                    radius: Config.style.roundingNormal

                    function onClicked(): void {
                        root.wrapper.detach("winfo");
                    }
                }

                Icon {
                    id: expandIcon

                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: font.pixelSize * 0.05

                    text: "chevron_right"

                    font.pixelSize: Config.style.fontSizeLarge
                }
            }
        }

        ClippingWrapperRectangle {
            color: "transparent"
            radius: Config.style.roundingSmall

            ScreencopyView {
                id: preview

                captureSource: Hyprland.activeToplevel?.wayland ?? null
                live: visible

                constraintSize.width: Config.style.barWindowPreviewSize
                constraintSize.height: Config.style.barWindowPreviewSize
            }
        }
    }
}
