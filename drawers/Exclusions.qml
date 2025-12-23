pragma ComponentBehavior: Bound

import qs.Components
import qs.Config
import Quickshell
import QtQuick

Scope {
    id: root

    required property ShellScreen screen

    ExclusionZone {
        anchors.left: true
    }

    ExclusionZone {
        anchors.top: true
    }

    ExclusionZone {
        anchors.right: true
    }

    ExclusionZone {
        anchors.bottom: true
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen
        name: "border-exclusion"
        exclusiveZone: Config.style.borderThickness 
        mask: Region {}
    }
}
