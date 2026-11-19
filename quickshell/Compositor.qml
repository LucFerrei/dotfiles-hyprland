import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.I3

QtObject {
    id: root

    readonly property bool isHyprland: root.envIsSet("HYPRLAND_INSTANCE_SIGNATURE")
    readonly property bool isI3: !root.isHyprland && (root.envIsSet("SWAYSOCK") || root.envIsSet("I3SOCK"))

    function envIsSet(name) {
        // Quickshell.env() returns null (not "") when the variable is unset.
        const value = Quickshell.env(name);
        return value !== null && value !== undefined && value !== "";
    }

    readonly property var workspaces: root.isHyprland ? Hyprland.workspaces.values : I3.workspaces.values
    readonly property var monitors: root.isHyprland ? Hyprland.monitors.values : I3.monitors.values

    readonly property string focusedMonitorName: {
        const monitor = root.isHyprland ? Hyprland.focusedMonitor : I3.focusedMonitor;
        return monitor ? monitor.name : "";
    }

    function monitorFor(screen) {
        if (root.isHyprland)
            return Hyprland.monitorFor(screen);
        return I3.monitorFor(screen);
    }

    function workspaceNumber(workspace) {
        if (workspace.number !== undefined)
            return workspace.number;
        if (workspace.num !== undefined)
            return workspace.num;
        return workspace.id;
    }

    function dispatchWorkspace(id) {
        if (root.isHyprland)
            Hyprland.dispatch("workspace " + id);
        else
            I3.dispatch("workspace " + id);
    }

    function exitSession() {
        if (root.isHyprland)
            Hyprland.dispatch("exit");
        else
            I3.dispatch("exit");
    }
}
