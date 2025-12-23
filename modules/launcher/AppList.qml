pragma ComponentBehavior: Bound

import "items"
import "services"
import qs.Components
import qs.Services
import qs.Config
import Quickshell
import QtQuick
import QtQuick.Controls

StyledListView {
    id: root

    required property TextField search
    required property PersistentProperties visibilities

    model: ScriptModel {
        id: model

        onValuesChanged: root.currentIndex = 0
    }

    spacing: Config.style.spacingSmall
    orientation: Qt.Vertical
    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    highlightMoveDuration: Config.animation.animDurations.normal
    highlightResizeDuration: 0

    highlight: StyledRect {
        radius: Config.style.roundingFull
        color: Config.colours.accentPrimary
        opacity: 0.08
    }

    state: {
        const text = search.text;
        const prefix = Config.launcher.actionPrefix;
        if (text.startsWith(prefix)) {
            for (const action of ["calc", "scheme", "variant"])
                if (text.startsWith(`${prefix}${action} `))
                    return action;

            return "actions";
        }

        return "apps";
    }

    states: [
        State {
            name: "apps"

            PropertyChanges {
                model.values: Apps.query(search.text)
                root.delegate: appItem
            }
        },
        State {
            name: "actions"

            PropertyChanges {
                model.values: Actions.query(search.text)
                root.delegate: actionItem
            }
        },
        State {
            name: "calc"

            PropertyChanges {
                model.values: [0]
                root.delegate: calcItem
            }
        },
        State {
            name: "scheme"

            PropertyChanges {
                model.values: Schemes.query(search.text)
                root.delegate: schemeItem
            }
        },
        State {
            name: "variant"

            PropertyChanges {
                model.values: M3Variants.query(search.text)
                root.delegate: variantItem
            }
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Config.animation.animDurations.small
                    easing.bezierCurve: Config.animation.animCurves.standardAccel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 1
                    to: 0.9
                    duration: Config.animation.animDurations.small
                    easing.bezierCurve: Config.animation.animCurves.standardAccel
                }
            }
            PropertyAction {
                targets: [model, root]
                properties: "values,delegate"
            }
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Config.animation.animDurations.small
                    easing.bezierCurve: Config.animation.animCurves.standardDecel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 0.9
                    to: 1
                    duration: Config.animation.animDurations.small
                    easing.bezierCurve: Config.animation.animCurves.standardDecel
                }
            }
            PropertyAction {
                targets: [root.add, root.remove]
                property: "enabled"
                value: true
            }
        }
    }

    ScrollBar.vertical: StyledScrollBar {}

    add: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 0
            to: 1
        }
    }

    remove: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 1
            to: 0
        }
    }

    move: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    addDisplaced: Transition {
        Anim {
            property: "y"
            duration: Config.animation.animDurations.small
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    displaced: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    Component {
        id: appItem

        AppItem {
            visibilities: root.visibilities
        }
    }

    Component {
        id: actionItem

        ActionItem {
            list: root
        }
    }

    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }

    Component {
        id: schemeItem

        SchemeItem {
            list: root
        }
    }

    Component {
        id: variantItem

        VariantItem {
            list: root
        }
    }

    component Anim: NumberAnimation {
        duration: Config.animation.animDurations.normal
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Config.animation.animCurves.standard
    }
}
