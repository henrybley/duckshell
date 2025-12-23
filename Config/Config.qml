pragma Singleton

import Quickshell

Singleton {
    id: root
    property string shellName: "duckshell"
    property string configDir: Quickshell.env("HOME") + "/.config/" + shellName + "/"
    readonly property Colours colours: Colours {configDir: root.configDir}
    readonly property Style style: Style {configDir: root.configDir}
    readonly property Animation animation: Animation {configDir: root.configDir}
    readonly property Launcher launcher: Launcher {}
    readonly property Notification notification: Notification {}
}
