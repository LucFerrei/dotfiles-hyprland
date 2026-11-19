import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Networking

PanelWindow {
    id: popup

    required property BarState state

    Theme { id: theme }

    property int popupWidth: 360
    property var pendingNetwork: null
    property string password: ""

    readonly property int contentWidth: popup.popupWidth - 24
    readonly property var wifiDevice: {
        for (const device of Networking.devices.values) {
            if (device.type === DeviceType.Wifi)
                return device;
        }
        return null;
    }

    visible: popup.state.network
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

    function networkList() {
        if (!popup.wifiDevice)
            return [];
        const networks = popup.wifiDevice.networks.values.slice();
        networks.sort(function(a, b) {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1;
            return (b.signalStrength || 0) - (a.signalStrength || 0);
        });
        return networks;
    }

    function connectTo(network) {
        if (!network)
            return;
        if (network.connected) {
            network.disconnect();
        } else if (network.security === WifiSecurityType.Open || network.known) {
            network.connect();
        } else {
            popup.pendingNetwork = network;
            popup.password = "";
            Qt.callLater(function() {
                passwordInput.forceActiveFocus();
            });
        }
    }

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

            Item {
                width: popup.contentWidth
                height: 30

                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Wi-Fi"
                    color: theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize + 3
                    font.bold: true
                }

                ToggleButton {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    label: Networking.wifiEnabled ? "Ligado" : "Desligado"
                    checked: Networking.wifiEnabled
                    accent: theme.green
                    onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
                }
            }

            Text {
                visible: !popup.wifiDevice
                text: "Nenhum adaptador Wi-Fi encontrado"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Flickable {
                visible: popup.wifiDevice !== null
                width: popup.contentWidth
                height: Math.min(networkColumn.implicitHeight, 340)
                contentHeight: networkColumn.implicitHeight
                clip: true

                Column {
                    id: networkColumn
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: popup.networkList()

                        Rectangle {
                            required property var modelData

                            width: networkColumn.width
                            height: 34
                            radius: 9
                            color: modelData.connected ? Qt.rgba(theme.green.r, theme.green.g, theme.green.b, 0.20) : theme.surface

                            Row {
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 8
                                    rightMargin: 8
                                }
                                spacing: 8

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "\uf1eb"
                                    color: modelData.connected ? theme.green : theme.subtext
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 170
                                    text: modelData.name
                                    elide: Text.ElideRight
                                    color: theme.text
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                    font.bold: modelData.connected
                                }

                                Item { width: 1; height: 1 }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Math.round(modelData.signalStrength || 0) + "%"
                                    color: theme.subtext
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize - 1
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: modelData.security !== WifiSecurityType.Open
                                    text: "\uf023"
                                    color: theme.overlay
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize - 2
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: popup.connectTo(modelData)
                            }
                        }
                    }
                }
            }

            Rectangle {
                visible: popup.pendingNetwork !== null
                width: popup.contentWidth
                height: visible ? 36 : 0
                radius: 9
                color: theme.surface

                Row {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                    }
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf023"
                        color: theme.overlay
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }

                    TextInput {
                        id: passwordInput
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 30
                        focus: true
                        echoMode: TextInput.Password
                        color: theme.text
                        selectionColor: theme.mauve
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                        Keys.onReturnPressed: {
                            if (popup.pendingNetwork) {
                                popup.pendingNetwork.connectWithPsk(text);
                                popup.pendingNetwork = null;
                                popup.password = "";
                            }
                        }
                        onTextChanged: popup.password = text
                    }
                }
            }

            ActionButton {
                label: "Abrir nmtui"
                accent: theme.blue
                onClicked: Quickshell.execDetached(["ghostty", "-e", "nmtui"])
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: popup.visible
        onActivated: popup.state.closeAll()
    }
}
