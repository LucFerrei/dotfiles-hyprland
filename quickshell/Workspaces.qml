import QtQuick
import Quickshell

Rectangle {
    id: root

    required property var barScreen
    required property Compositor compositor
    property var workspaceModel: []

    Theme { id: theme }

    implicitWidth: row.implicitWidth + 10
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill

    onBarScreenChanged: root.rebuild()

    Component.onCompleted: root.rebuild()

    Connections {
        target: root.compositor
        function onWorkspacesChanged() {
            root.rebuild();
        }
        function onMonitorsChanged() {
            root.rebuild();
        }
    }

    function rebuild() {
        const monitors = root.compositor.monitors;
        const monitor = root.compositor.monitorFor(root.barScreen);
        const hasMonitor = monitor !== null && monitor !== undefined && monitors.length > 0;

        const existing = root.compositor.workspaces.filter(function(ws) {
            if (ws.name.indexOf("special") === 0)
                return false;
            return !hasMonitor || ws.monitor === monitor;
        });

        const result = [];
        for (let id = 1; id <= 5; id++) {
            let found = null;
            for (const ws of existing) {
                if (root.compositor.workspaceNumber(ws) === id) {
                    found = ws;
                    break;
                }
            }

            if (found) {
                result.push(found);
            } else {
                result.push({
                    id: id,
                    name: String(id),
                    focused: false,
                    urgent: false,
                    activate: function() {
                        root.compositor.dispatchWorkspace(id);
                    }
                });
            }
        }

        for (const ws of existing) {
            if (root.compositor.workspaceNumber(ws) > 5)
                result.push(ws);
        }

        root.workspaceModel = result;
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 2

        Repeater {
            model: root.workspaceModel

            Rectangle {
                id: button

                required property var modelData

                width: Math.max(26, label.implicitWidth + 14)
                height: 24
                radius: 8
                color: "transparent"
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: button.modelData.focused ? theme.pink : "transparent"
                    }
                    GradientStop {
                        position: 1.0
                        color: button.modelData.focused ? theme.mauve : "transparent"
                    }
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    text: button.modelData.name
                    color: button.modelData.focused ? theme.crust : (button.modelData.urgent ? theme.red : theme.text)
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: button.modelData.activate()
                }
            }
        }
    }
}
