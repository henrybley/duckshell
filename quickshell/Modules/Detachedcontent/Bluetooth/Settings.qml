pragma ComponentBehavior: Bound

import ".."
import qs.Components
import qs.Services
import qs.Config
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

ColumnLayout {
    id: root

    required property Session session

    spacing: Config.style.spacingNormal

    Icon {
        Layout.alignment: Qt.AlignHCenter
        text: "bluetooth"
        font.pixelSize: Appearance.font.size.extraLarge * 3
        font.bold: true
    }

    StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Bluetooth settings")
        font.pixelSize: Config.style.fontSizeLarge
        font.bold: true
    }

    StyledText {
        Layout.topMargin: Config.style.spacingLarge
        text: qsTr("Adapter status")
        font.pixelSize: Config.style.fontSizeLarger
        font.weight: 500
    }

    StyledText {
        text: qsTr("General adapter settings")
        color: Colours.palette.m3outline
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: adapterStatus.implicitHeight + Config.style.paddingLarge * 2

        radius: Config.style.roundingNormal
        color: Config.colours.backgroundLight

        ColumnLayout {
            id: adapterStatus

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Config.style.paddingLarge

            spacing: Config.style.spacingLarger

            Toggle {
                label: qsTr("Powered")
                checked: Bluetooth.defaultAdapter?.enabled ?? false
                toggle.onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter)
                        adapter.enabled = checked;
                }
            }

            Toggle {
                label: qsTr("Discoverable")
                checked: Bluetooth.defaultAdapter?.discoverable ?? false
                toggle.onToggled: {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter)
                        adapter.discoverable = checked;
                }
            }
        }
    }

    StyledText {
        Layout.topMargin: Config.style.spacingLarge
        text: qsTr("Adapter properties")
        font.pixelSize: Config.style.fontSizeLarger
        font.weight: 500
    }

    StyledText {
        text: qsTr("Per-adapter settings")
        color: Colours.palette.m3outline
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: adapterSettings.implicitHeight + Config.style.paddingLarge * 2

        radius: Config.style.roundingNormal
        color: Config.colours.backgroundLight

        ColumnLayout {
            id: adapterSettings

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Config.style.paddingLarge

            spacing: Config.style.spacingLarger

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.style.spacingNormal

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Current adapter")
                }

                Item {
                    id: adapterPickerButton

                    property bool expanded

                    implicitWidth: adapterPicker.implicitWidth + Config.style.paddingNormal * 2
                    implicitHeight: adapterPicker.implicitHeight + Config.style.paddingNormal * 2

                    StateLayer {
                        radius: Config.style.roundingSmall

                        function onClicked(): void {
                            adapterPickerButton.expanded = !adapterPickerButton.expanded;
                        }
                    }

                    RowLayout {
                        id: adapterPicker

                        anchors.fill: parent
                        anchors.margins: Config.style.paddingNormal
                        spacing: Config.style.spacingNormal

                        StyledText {
                            Layout.leftMargin: Config.style.paddingSmall
                            text: Bluetooth.defaultAdapter?.name ?? qsTr("None")
                        }

                        Icon {
                            text: "expand_more"
                        }
                    }

                    RectangularShadow {
                        anchors.fill: adapterListBg
                        radius: adapterListBg.radius
                        color: Qt.alpha(Colours.palette.m3shadow, 0.7)
                        opacity: adapterPickerButton.expanded ? 1 : 0
                        scale: adapterPickerButton.expanded ? 1 : 0.7
                        blur: 5
                        spread: 0

                        Behavior on opacity {
                            Anim {}
                        }

                        Behavior on scale {
                            Anim {
                                duration: Config.animation.animDurations.expressiveFastSpatial
                                easing.bezierCurve: Config.animation.animCurves.expressiveFastSpatial
                            }
                        }
                    }

                    StyledClippingRect {
                        id: adapterListBg

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        implicitHeight: adapterPickerButton.expanded ? adapterList.implicitHeight : adapterPickerButton.implicitHeight

                        color: Colours.palette.m3secondaryContainer
                        radius: Config.style.roundingSmall
                        opacity: adapterPickerButton.expanded ? 1 : 0
                        scale: adapterPickerButton.expanded ? 1 : 0.7

                        ColumnLayout {
                            id: adapterList

                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            spacing: 0

                            Repeater {
                                model: Bluetooth.adapters

                                Item {
                                    id: adapter

                                    required property BluetoothAdapter modelData

                                    Layout.fillWidth: true
                                    implicitHeight: adapterInner.implicitHeight + Config.style.paddingNormal * 2

                                    StateLayer {
                                        enabled: adapterPickerButton.expanded

                                        function onClicked(): void {
                                            adapterPickerButton.expanded = false;
                                            root.session.bt.currentAdapter = adapter.modelData;
                                        }
                                    }

                                    RowLayout {
                                        id: adapterInner

                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.margins: Config.style.paddingNormal
                                        spacing: Config.style.spacingNormal

                                        StyledText {
                                            Layout.fillWidth: true
                                            Layout.leftMargin: Config.style.paddingSmall
                                            text: adapter.modelData.name
                                            color: Config.colours.backgroundLightContainer
                                        }

                                        Icon {
                                            text: "check"
                                            color: Config.colours.backgroundLightContainer
                                            visible: adapter.modelData === root.session.bt.currentAdapter
                                        }
                                    }
                                }
                            }
                        }

                        Behavior on opacity {
                            Anim {}
                        }

                        Behavior on scale {
                            Anim {
                                duration: Config.animation.animDurations.expressiveFastSpatial
                                easing.bezierCurve: Config.animation.animCurves.expressiveFastSpatial
                            }
                        }

                        Behavior on implicitHeight {
                            Anim {
                                duration: Config.animation.animDurations.expressiveDefaultSpatial
                                easing.bezierCurve: Config.animation.animCurves.expressiveDefaultSpatial
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.style.spacingNormal

                StyledText {
                    Layout.fillWidth: true
                    text: qsTr("Discoverable timeout")
                }

                CustomSpinBox {
                    min: 0
                    value: root.session.bt.currentAdapter.discoverableTimeout
                    onValueModified: value => root.session.bt.currentAdapter.discoverableTimeout = value
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Config.style.spacingSmall

                Item {
                    id: renameAdapter

                    Layout.fillWidth: true
                    Layout.rightMargin: Config.style.spacingSmall

                    implicitHeight: renameLabel.implicitHeight + adapterNameEdit.implicitHeight

                    states: State {
                        name: "editingAdapterName"
                        when: root.session.bt.editingAdapterName

                        AnchorChanges {
                            target: adapterNameEdit
                            anchors.top: renameAdapter.top
                        }
                        PropertyChanges {
                            renameAdapter.implicitHeight: adapterNameEdit.implicitHeight
                            renameLabel.opacity: 0
                            adapterNameEdit.padding: Config.style.paddingNormal
                        }
                    }

                    transitions: Transition {
                        AnchorAnimation {
                            duration: Config.animation.animDurations.normal
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Config.animation.animCurves.standard
                        }
                        Anim {
                            properties: "implicitHeight,opacity,padding"
                        }
                    }

                    StyledText {
                        id: renameLabel

                        anchors.left: parent.left

                        text: qsTr("Rename adapter (currently does not work)")  // FIXME: remove disclaimer when fixed
                        color: Colours.palette.m3outline
                        font.pixelSize: Config.style.fontSizeSmall
                    }

                    StyledTextField {
                        id: adapterNameEdit

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: renameLabel.bottom
                        anchors.leftMargin: root.session.bt.editingAdapterName ? 0 : -Config.style.paddingNormal

                        text: root.session.bt.currentAdapter.name
                        readOnly: !root.session.bt.editingAdapterName
                        onAccepted: {
                            root.session.bt.editingAdapterName = false;
                            // Doesn't work for now, will be added to QS later
                            // root.session.bt.currentAdapter.name = text;
                        }

                        leftPadding: Config.style.paddingNormal
                        rightPadding: Config.style.paddingNormal

                        background: StyledRect {
                            radius: Config.style.roundingSmall
                            border.width: 2
                            border.color: Config.colours.textPrimary
                            opacity: root.session.bt.editingAdapterName ? 1 : 0

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: Config.animation.animDurations.normal
                                    easing.type: Easing.BezierSpline
                                    easing.bezierCurve: Config.animation.animCurves.standard
                                }
                            }

                            Behavior on opacity {
                                Anim {}
                            }
                        }

                        Behavior on anchors.leftMargin {
                            Anim {}
                        }
                    }
                }

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: cancelEditIcon.implicitHeight + Config.style.paddingSmaller * 2

                    radius: implicitHeight / 2
                    color: Colours.palette.m3secondaryContainer
                    opacity: root.session.bt.editingAdapterName ? 1 : 0
                    scale: root.session.bt.editingAdapterName ? 1 : 0.5

                    StateLayer {
                        color: Config.colours.backgroundLightContainer
                        disabled: !root.session.bt.editingAdapterName

                        function onClicked(): void {
                            root.session.bt.editingAdapterName = false;
                            adapterNameEdit.text = Qt.binding(() => root.session.bt.currentAdapter.name);
                        }
                    }

                    Icon {
                        id: cancelEditIcon

                        anchors.centerIn: parent
                        animate: true
                        text: "cancel"
                        color: Config.colours.backgroundLightContainer
                    }

                    Behavior on opacity {
                        Anim {}
                    }

                    Behavior on scale {
                        Anim {
                            duration: Config.animation.animDurations.expressiveFastSpatial
                            easing.bezierCurve: Config.animation.animCurves.expressiveFastSpatial
                        }
                    }
                }

                StyledRect {
                    implicitWidth: implicitHeight
                    implicitHeight: editIcon.implicitHeight + Config.style.paddingSmaller * 2

                    radius: root.session.bt.editingAdapterName ? implicitHeight / 2 : Config.style.roundingSmall
                    color: root.session.bt.editingAdapterName ? Config.colours.textPrimary : "transparent"

                    StateLayer {
                        color: root.session.bt.editingAdapterName ? Config.colours.backgroundPrimary : Config.colours.backgroundLight

                        function onClicked(): void {
                            root.session.bt.editingAdapterName = !root.session.bt.editingAdapterName;
                            if (root.session.bt.editingAdapterName)
                                adapterNameEdit.forceActiveFocus();
                            else
                                adapterNameEdit.accepted();
                        }
                    }

                    Icon {
                        id: editIcon

                        anchors.centerIn: parent
                        animate: true
                        text: root.session.bt.editingAdapterName ? "check_circle" : "edit"
                        color: root.session.bt.editingAdapterName ? Config.colours.backgroundPrimary : Config.colours.backgroundLight
                    }

                    Behavior on radius {
                        Anim {}
                    }
                }
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }

    component Toggle: RowLayout {
        required property string label
        property alias checked: toggle.checked
        property alias toggle: toggle

        Layout.fillWidth: true
        spacing: Config.style.spacingNormal

        StyledText {
            Layout.fillWidth: true
            text: parent.label
        }

        StyledSwitch {
            id: toggle
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
