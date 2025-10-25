pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.Services

Singleton {
    id: root

    property ListModel workspaces: ListModel {}
    property bool isHyprland: false
    // Detect which compositor we're using
    Component.onCompleted: {
        console.log("WorkspaceManager initializing...");
        detectCompositor();
    }

    function detectCompositor() {
        try {
            try {
                if (Hyprland.eventSocketPath) {
                    console.log("Detected Hyprland compositor");
                    isHyprland = true;
                    initHyprland();
                    return;
                }
            } catch (e) {
                console.log("Hyprland not available:", e);
            }
            
            console.log("No supported compositor detected");
        } catch (e) {
            console.error("Error detecting compositor:", e);
        }
    }

    // Initialize Hyprland integration
    function initHyprland() {
        try {            
            Hyprland.refreshWorkspaces();
            updateHyprlandWorkspaces();
            return true;
        } catch (e) {
            console.error("Error initializing Hyprland:", e);
            isHyprland = false;
            return false;
        }
    }

    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateHyprlandWorkspaces();
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            updateHyprlandWorkspaces();
        }
    }

    function updateHyprlandWorkspaces() {
        workspaces.clear();

        for (let i = 1; i < 11; i++) {
            workspaces.append({
                id: i,
                idx: i,
                name: "",
                output: "",
                isActive: false,
                isFocused: false,
                isUrgent: false
            });
        }

        try {
            for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                const ws = Hyprland.workspaces.values[i];
                workspaces.set(ws.id - 1, {
                    id: ws.id,
                    idx: ws.id,
                    name: ws.name || "",
                    output: ws.monitor?.name || "",
                    isActive: ws.active === true,
                    isFocused: ws.focused === true,
                    isUrgent: ws.urgent === true
                });
            }
            workspacesChanged();
        } catch (e) {
            console.error("Error updating Hyprland workspaces:", e);
        }
    }


    function switchToWorkspace(workspaceId) {    
        if (isHyprland) {
            try {
                Hyprland.dispatch(`workspace ${workspaceId}`);
            } catch (e) {
                console.error("Error switching Hyprland workspace:", e);
            }
        } else {
            console.warn("No supported compositor detected for workspace switching");
        }
    }
}
