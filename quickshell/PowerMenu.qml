import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: popup

    required property BarState state
    required property Compositor compositor

    Theme { id: theme }

    property int popupWidth: 280

    readonly property int contentWidth: popup.popupWidth - 24

    property Process actionProcess: Process {
        running: false
    }

    function run(command) {
        popup.actionProcess.command = command;
        popup.actionProcess.running = true;
    }

    visible: popup.state.power
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusiveZone: 0
    aboveWindows: true
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-popup"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    MouseArea {
        anchors.fill: parent
        onClicked: popup.state.closeAll()
    }

    Rectangle {
        id: panel
        anchors {
            top: parent.top
            right: parent.right
            topMargin: theme.popupTopMargin
            rightMargin: 8
        }
        width: popup.popupWidth
        implicitHeight: content.implicitHeight + 24
        radius: 14
        color: theme.panel
        border.width: 1
        border.color: theme.outline

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 10

            Text {
                text: "Energia"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize + 3
                font.bold: true
            }

            Flow {
                width: popup.contentWidth
                spacing: 8

                ActionButton {
                    label: "Bloquear"
                    accent: theme.text
                    onClicked: popup.run(["swaylock", "-f"])
                }

                ActionButton {
                    label: "Suspender"
                    accent: theme.yellow
                    onClicked: popup.run(["systemctl", "suspend"])
                }

                ActionButton {
                    label: "Sair"
                    accent: theme.peach
                    onClicked: popup.compositor.exitSession()
                }

                ActionButton {
                    label: "Reiniciar"
                    accent: theme.mauve
                    onClicked: popup.run(["systemctl", "reboot"])
                }

                ActionButton {
                    label: "Desligar"
                    accent: theme.red
                    onClicked: popup.run(["systemctl", "poweroff"])
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: popup.visible
        onActivated: popup.state.closeAll()
    }
}
