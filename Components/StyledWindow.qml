import Quickshell
import Quickshell.Wayland

PanelWindow {
    required property string name

    WlrLayershell.namespace: `DuckShell-${name}`
    color: "transparent"
}
