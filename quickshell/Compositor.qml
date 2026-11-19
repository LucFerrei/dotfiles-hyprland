import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.I3

QtObject {
    id: root

    readonly property bool isHyprland: root.envIsSet("HYPRLAND_INSTANCE_SIGNATURE")
    readonly property bool isI3: !root.isHyprland && (root.envIsSet("SWAYSOCK") || root.envIsSet("I3SOCK"))

    // Disparado quando um workspace muda de monitor (ou número/nome) sem que
    // nenhum workspace seja criado/destruído. O Quickshell trata esses casos
    // in-place (updateFromObject), sem alterar os models, então eles NÃO
    // disparam workspacesChanged/monitorsChanged e precisam deste sinal.
    signal workspaceLayoutChanged()

    function envIsSet(name) {
        // Quickshell.env() returns null (not "") when the variable is unset.
        const value = Quickshell.env(name);
        return value !== null && value !== undefined && value !== "";
    }

    // Hyprland: `workspace N` move workspaces entre monitores no uso normal
    // (moveworkspacev2) e renames mudam o slot do workspace.
    // (QtObject não tem default property, por isso os Connections são
    // declarados como propriedades nomeadas.)
    readonly property Connections hyprlandEvents: Connections {
        target: root.isHyprland ? Hyprland : null

        function onRawEvent(event) {
            if (event.name === "moveworkspacev2" || event.name === "renameworkspace")
                root.workspaceLayoutChanged();
        }
    }

    // i3/sway: `move workspace to output ...` emite um evento workspace com
    // change=move (também focus/rename/urgent), tudo tratado in-place.
    readonly property Connections i3Events: Connections {
        target: root.isI3 ? I3 : null

        function onRawEvent(event) {
            if (event.type === "workspace")
                root.workspaceLayoutChanged();
        }
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
            // Igual aos keybinds do sway e ao I3Workspace.activate(): casa por
            // número, não por nome exato (evita workspace duplicado se o nome
            // algum dia não for puramente numérico, ex. "2:web").
            I3.dispatch("workspace number " + id);
    }

    function exitSession() {
        if (root.isHyprland)
            Hyprland.dispatch("exit");
        else
            I3.dispatch("exit");
    }
}
