import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: bar

    required property SysStats stats
    required property BarState state
    required property NotificationHub hub
    required property Compositor compositor

    Theme { id: theme }

    color: "transparent"
    implicitHeight: theme.barHeight
    exclusiveZone: theme.barHeight + 4
    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        top: 4
        left: 8
        right: 8
    }

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell-bar"

    Item {
        anchors.fill: parent

        Row {
            id: leftRow
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            spacing: theme.gap

            Workspaces {
                barScreen: bar.screen
                compositor: bar.compositor
            }

            ActiveWindow {}
        }

        Row {
            id: centerRow
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            spacing: theme.gap

            MediaModule {
                state: bar.state
            }

            ClockModule {
                state: bar.state
            }
        }

        Row {
            id: rightRow
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: theme.gap

            AudioModule {
                state: bar.state
            }

            NetworkModule {
                state: bar.state
            }

            BluetoothModule {
                state: bar.state
            }

            BatteryModule {
                state: bar.state
            }

            SysModule {
                stats: bar.stats
            }

            SystemModule {
                state: bar.state
                hub: bar.hub
            }
        }
    }
}
