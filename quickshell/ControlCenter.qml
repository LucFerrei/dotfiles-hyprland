import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

PanelWindow {
    id: popup

    required property BarState state
    required property NotificationHub hub
    required property SysStats stats
    required property Compositor compositor

    Theme { id: theme }

    property int popupWidth: 380

    readonly property int contentWidth: popup.popupWidth - 24
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var battery: UPower.displayDevice

    property Process actionProcess: Process {
        running: false
    }

    function run(command) {
        popup.actionProcess.command = command;
        popup.actionProcess.running = true;
    }

    function batteryText() {
        if (!popup.battery || !popup.battery.isPresent)
            return "Sem bateria";
        let text = Math.round(popup.battery.percentage) + "%";
        if (popup.battery.state === UPowerDeviceState.Charging)
            text += " (carregando)";
        else if (popup.battery.state === UPowerDeviceState.FullyCharged)
            text += " (cheia)";
        else if (popup.battery.timeToEmpty > 0)
            text += " · " + Math.floor(popup.battery.timeToEmpty / 3600) + "h" + (Math.floor(popup.battery.timeToEmpty / 60) % 60) + "min restantes";
        return text;
    }

    visible: popup.state.control
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
            spacing: 9

            Text {
                text: "Controle"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize + 3
                font.bold: true
            }

            Text {
                text: "Volume"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                width: popup.contentWidth
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.sink && popup.sink.audio && popup.sink.audio.muted ? "\uf026" : "\uf028"
                    color: popup.sink && popup.sink.audio && popup.sink.audio.muted ? theme.red : theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (popup.sink && popup.sink.audio)
                                popup.sink.audio.muted = !popup.sink.audio.muted;
                        }
                    }
                }

                Slider {
                    anchors.verticalCenter: parent.verticalCenter
                    width: popup.contentWidth - 70
                    value: popup.sink && popup.sink.audio ? popup.sink.audio.volume : 0
                    from: 0
                    to: 1.5
                    fillColor: theme.green
                    onMoved: value => {
                        if (popup.sink && popup.sink.audio)
                            popup.sink.audio.volume = value;
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.sink && popup.sink.audio ? Math.round(popup.sink.audio.volume * 100) + "%" : "--"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }
            }

            Text {
                text: "Microfone"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                width: popup.contentWidth
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.source && popup.source.audio && popup.source.audio.muted ? "\uf131" : "\uf130"
                    color: popup.source && popup.source.audio && popup.source.audio.muted ? theme.red : theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (popup.source && popup.source.audio)
                                popup.source.audio.muted = !popup.source.audio.muted;
                        }
                    }
                }

                Slider {
                    anchors.verticalCenter: parent.verticalCenter
                    width: popup.contentWidth - 70
                    value: popup.source && popup.source.audio ? popup.source.audio.volume : 0
                    from: 0
                    to: 1.5
                    fillColor: theme.blue
                    onMoved: value => {
                        if (popup.source && popup.source.audio)
                            popup.source.audio.volume = value;
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.source && popup.source.audio ? Math.round(popup.source.audio.volume * 100) + "%" : "--"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }
            }

            Text {
                text: "Brilho"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                width: popup.contentWidth
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf185"
                    color: theme.yellow
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }

                Slider {
                    anchors.verticalCenter: parent.verticalCenter
                    width: popup.contentWidth - 70
                    value: popup.stats.brightness / 100
                    from: 0
                    to: 1
                    fillColor: theme.yellow
                    onMoved: value => popup.stats.setBrightness(value * 100)
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.stats.brightness + "%"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }
            }

            Rectangle {
                width: popup.contentWidth
                height: 1
                color: theme.outline
            }

            Row {
                width: popup.contentWidth
                spacing: 8

                ToggleButton {
                    label: "Wi-Fi"
                    checked: Networking.wifiEnabled
                    accent: theme.green
                    onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
                }

                ToggleButton {
                    label: "Bluetooth"
                    checked: popup.adapter ? popup.adapter.enabled : false
                    accent: theme.blue
                    onToggled: {
                        if (popup.adapter)
                            popup.adapter.enabled = !popup.adapter.enabled;
                    }
                }

                ToggleButton {
                    label: popup.hub.dnd ? "Não perturbar" : "Notificações"
                    checked: popup.hub.dnd
                    accent: theme.red
                    onToggled: popup.hub.dnd = !popup.hub.dnd
                }
            }

            Text {
                visible: PowerProfiles.hasPerformanceProfile
                text: "Perfil de energia"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                visible: PowerProfiles.hasPerformanceProfile
                width: popup.contentWidth
                spacing: 8

                ToggleButton {
                    label: "Economia"
                    checked: PowerProfiles.profile === PowerProfile.PowerSaver
                    accent: theme.teal
                    onToggled: PowerProfiles.profile = PowerProfile.PowerSaver
                }

                ToggleButton {
                    label: "Equilibrado"
                    checked: PowerProfiles.profile === PowerProfile.Balanced
                    accent: theme.yellow
                    onToggled: PowerProfiles.profile = PowerProfile.Balanced
                }

                ToggleButton {
                    label: "Desempenho"
                    visible: PowerProfiles.hasPerformanceProfile
                    checked: PowerProfiles.profile === PowerProfile.Performance
                    accent: theme.red
                    onToggled: PowerProfiles.profile = PowerProfile.Performance
                }
            }

            Text {
                text: popup.batteryText()
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Rectangle {
                width: popup.contentWidth
                height: 1
                color: theme.outline
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
