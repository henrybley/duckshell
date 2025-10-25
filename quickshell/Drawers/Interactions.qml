import qs.Services
import qs.Config
import qs.Modules.Bar.Popouts as BarPopouts
import qs.Modules.Audio as AudioPanel
import Quickshell
import QtQuick

MouseArea {
    id: root

    required property ShellScreen screen
    required property BarPopouts.Wrapper popouts
    required property PersistentProperties visibilities
    required property Panels panels

    property bool audioHovered
    property point dragStart
    property bool dashboardShortcutActive
    property bool audioShortcutActive
    property bool utilitiesShortcutActive

    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        return y >= panel.y - Config.style.borderRounding && y <= panelY + panel.height + Config.style.borderRounding;
    }

    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        return x >= panel.x - Config.style.borderRounding && x <= panelX + panel.width + Config.style.borderRounding;
    }

    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > Config.style.borderThickness + panel.x && withinPanelHeight(panel, x, y);
    }

    function inTopPanel(panel: Item, x: real, y: real): bool {
        return y < Config.style.borderThickness + panel.y + panel.height && withinPanelWidth(panel, x, y);
    }

    function inBottomPanel(panel: Item, x: real, y: real): bool {
        return y > root.height - Config.style.borderThickness - panel.height - Config.style.borderRounding && withinPanelWidth(panel, x, y);
    }

    anchors.fill: parent
    hoverEnabled: true

    onPressed: event => dragStart = Qt.point(event.x, event.y)
    onContainsMouseChanged: {
        if (!containsMouse) {
            // Only hide if not activated by shortcut
            if (!audioShortcutActive) {
                visibilities.audio = false;
                audioHovered = false;
            }

            if (!dashboardShortcutActive)
                visibilities.dashboard = false;

            if (!utilitiesShortcutActive)
                visibilities.utilities = false;

            if (!popouts.currentName.startsWith("traymenu"))
                popouts.hasCurrent = false;

            bar.isHovered = false;
        }
    }

    onPositionChanged: event => {
        if (popouts.isDetached)
            return;

        const x = event.x;
        const y = event.y;

        // Show bar in non-exclusive mode on hover
        if (!visibilities.bar && x < bar.implicitWidth)
            bar.isHovered = true;

        // Show/hide bar on drag
        if (pressed && dragStart.x < bar.implicitWidth) {
            const dragX = x - dragStart.x;
            if (dragX > Config.bar.dragThreshold)
                visibilities.bar = true;
            else if (dragX < -Config.bar.dragThreshold)
                visibilities.bar = false;
        }

        // Show audio on hover
        const showAudioPanel = inRightPanel(panels.audio, x, y);

        // Always update visibility based on hover if not in shortcut mode
        if (!audioShortcutActive) {
            visibilities.audio = showAudioPanel;
            audioHovered = showAudioPanel;
        } else if (showAudioPanel) {
            // If hovering over OSD area while in shortcut mode, transition to hover control
            audioShortcutActive = false;
            audioHovered = true;
        }

        // Show/hide session on drag
        /*if (pressed && inRightPanel(panels.session, dragStart.x, dragStart.y) && withinPanelHeight(panels.session, x, y)) {
            const dragX = x - dragStart.x;
            if (dragX < -Config.session.dragThreshold)
                visibilities.session = true;
            else if (dragX > Config.session.dragThreshold)
                visibilities.session = false;
            }*/

        // Show/hide launcher on drag
        /*if (pressed && inBottomPanel(panels.launcher, dragStart.x, dragStart.y) && withinPanelWidth(panels.launcher, x, y)) {
            const dragY = y - dragStart.y;
            if (dragY < -Config.launcher.dragThreshold)
                visibilities.launcher = true;
            else if (dragY > Config.launcher.dragThreshold)
                visibilities.launcher = false;
            }*/

        // Show dashboard on hover
        //const showDashboard = inTopPanel(panels.dashboard, x, y);

        // Always update visibility based on hover if not in shortcut mode
        /*if (!dashboardShortcutActive) {
            visibilities.dashboard = showDashboard;
        } else if (showDashboard) {
            // If hovering over dashboard area while in shortcut mode, transition to hover control
            dashboardShortcutActive = false;
        }*/

        // Show/hide dashboard on drag (for touchscreen devices)
        /*if (pressed && inTopPanel(panels.dashboard, dragStart.x, dragStart.y) && withinPanelWidth(panels.dashboard, x, y)) {
            const dragY = y - dragStart.y;
            if (dragY > Config.dashboard.dragThreshold)
                visibilities.dashboard = true;
            else if (dragY < -Config.dashboard.dragThreshold)
                visibilities.dashboard = false;
            }*/

        // Show utilities on hover
        //const showUtilities = inBottomPanel(panels.utilities, x, y);

        // Always update visibility based on hover if not in shortcut mode
        /*if (!utilitiesShortcutActive) {
            visibilities.utilities = showUtilities;
        } else if (showUtilities) {
            // If hovering over utilities area while in shortcut mode, transition to hover control
            utilitiesShortcutActive = false;
        }*/

        // Show popouts on hover
        if (x < bar.implicitWidth)
            bar.checkPopout(y);
    }

    // Monitor individual visibility changes
    Connections {
        target: root.visibilities

        function onLauncherChanged() {
            // If launcher is hidden, clear shortcut flags for dashboard and OSD
            if (!root.visibilities.launcher) {
                root.dashboardShortcutActive = false;
                root.audioShortcutActive = false;
                root.utilitiesShortcutActive = false;

                // Also hide dashboard and OSD if they're not being hovered
                //const inDashboardArea = root.inTopPanel(root.panels.dashboard, root.mouseX, root.mouseY);
                const inAudioPanelArea = root.inRightPanel(root.panels.audio, root.mouseX, root.mouseY);

                /*if (!inDashboardArea) {
                    root.visibilities.dashboard = false;
                }*/
                if (!inAudioPanelArea) {
                    root.visibilities.audio = false;
                    root.audioHovered = false;
                }
            }
        }

        function onDashboardChanged() {
            if (root.visibilities.dashboard) {
                // Dashboard became visible, immediately check if this should be shortcut mode
                const inDashboardArea = root.inTopPanel(root.panels.dashboard, root.mouseX, root.mouseY);
                if (!inDashboardArea) {
                    root.dashboardShortcutActive = true;
                }
            } else {
                // Dashboard hidden, clear shortcut flag
                root.dashboardShortcutActive = false;
            }
        }

        function onAudioPanelChanged() {
            if (root.visibilities.audio) {
                // OSD became visible, immediately check if this should be shortcut mode
                const inAudioPanelArea = root.inRightPanel(root.panels.audio, root.mouseX, root.mouseY);
                if (!inAudioPanelArea) {
                    root.audioShortcutActive = true;
                }
            } else {
                // OSD hidden, clear shortcut flag
                root.audioShortcutActive = false;
            }
        }

        function onUtilitiesChanged() {
            if (root.visibilities.utilities) {
                // Utilities became visible, immediately check if this should be shortcut mode
                const inUtilitiesArea = root.inBottomPanel(root.panels.utilities, root.mouseX, root.mouseY);
                if (!inUtilitiesArea) {
                    root.utilitiesShortcutActive = true;
                }
            } else {
                // Utilities hidden, clear shortcut flag
                root.utilitiesShortcutActive = false;
            }
        }
    }

    AudioPanel.Interactions {
        screen: root.screen
        visibilities: root.visibilities
        hovered: root.audioHovered
    }
}
