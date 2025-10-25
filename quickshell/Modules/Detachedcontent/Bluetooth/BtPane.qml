pragma ComponentBehavior: Bound

import ".."
import qs.Components
import qs.Config
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property Session session

    anchors.fill: parent

    spacing: 0

    Item {
        Layout.preferredWidth: Math.floor(parent.width * 0.4)
        Layout.fillHeight: true

        DeviceList {
            anchors.margins: Config.style.paddingLarge + Config.style.paddingNormal
            anchors.leftMargin: Config.style.paddingLarge
            anchors.rightMargin: Config.style.paddingLarge + Config.style.paddingNormal / 2

            session: root.session
        }

        InnerBorder {
            leftThickness: 0
            rightThickness: Config.style.paddingNormal / 2
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Loader {
            anchors.fill: parent
            anchors.margins: Config.style.paddingLarge * 2 + Config.style.paddingNormal
            anchors.leftMargin: Config.style.paddingLarge * 2
            anchors.rightMargin: Config.style.paddingLarge * 2 + Config.style.paddingNormal / 2

            asynchronous: true
            sourceComponent: root.session.bt.active ? details : settings
        }

        InnerBorder {
            leftThickness: Config.style.paddingNormal / 2
        }

        Component {
            id: settings

            Settings {
                anchors.margins: Config.style.paddingNormal
                anchors.leftMargin: Config.style.paddingNormal / 2

                session: root.session
            }
        }

        Component {
            id: details

            Details {
                anchors.margins: Config.style.paddingNormal
                anchors.leftMargin: Config.style.paddingNormal / 2

                session: root.session
            }
        }
    }
}
