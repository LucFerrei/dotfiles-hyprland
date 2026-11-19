import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire

ShellRoot {
    id: shellRoot

    // Esconde o popup de "config reloaded" a cada reload.
    // (Popup de ERRO de reload continua aparecendo, o que é útil ao editar.)
    Connections {
        target: Quickshell
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }

    SysStats {
        id: sysStats
    }

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    NotificationServer {
        id: notificationServer
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        inlineReplySupported: true
        onNotification: notification => {
            notification.tracked = true;
            notificationHub.push(notification);
        }
    }

    NotificationHub {
        id: notificationHub
        server: notificationServer
    }

    Compositor {
        id: compositorService
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Item {
                required property var modelData

                BarState {
                    id: barState
                }

                Bar {
                    screen: modelData
                    stats: sysStats
                    state: barState
                    hub: notificationHub
                    compositor: compositorService
                }

                AudioPopup {
                    screen: modelData
                    state: barState
                }

                NetworkPopup {
                    screen: modelData
                    state: barState
                }

                BluetoothPopup {
                    screen: modelData
                    state: barState
                }

                CalendarPopup {
                    screen: modelData
                    state: barState
                }

                MediaPopup {
                    screen: modelData
                    state: barState
                }

                ControlCenter {
                    screen: modelData
                    state: barState
                    hub: notificationHub
                    stats: sysStats
                    compositor: compositorService
                }

                NotificationCenter {
                    screen: modelData
                    state: barState
                    hub: notificationHub
                    server: notificationServer
                }

                NotificationPopups {
                    targetScreen: modelData
                    hub: notificationHub
                    compositor: compositorService
                }

                PowerMenu {
                    screen: modelData
                    state: barState
                    compositor: compositorService
                }
            }
        }
    }
}
