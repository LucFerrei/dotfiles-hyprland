import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth

PanelWindow {
    id: popup

    required property BarState state

    Theme { id: theme }

    property int popupWidth: 360

    readonly property int contentWidth: popup.popupWidth - 24
    readonly property var adapter: Bluetooth.defaultAdapter

    visible: popup.state.bluetooth
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

    onVisibleChanged: {
        if (popup.adapter)
            popup.adapter.discovering = popup.visible && popup.adapter.enabled;
    }

    function deviceList() {
        if (!popup.adapter)
            return [];
        const devices = popup.adapter.devices.values.slice();
        devices.sort(function(a, b) {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1;
            return String(a.name).localeCompare(String(b.name));
        });
        return devices;
    }

    function toggleDevice(device) {
        if (!device)
            return;
        if (!device.paired)
            device.pair();
        else if (device.connected)
            device.disconnect();
        else
            device.connect();
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
                    text: "Bluetooth"
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
                    visible: popup.adapter !== null
                    label: popup.adapter && popup.adapter.enabled ? "Ligado" : "Desligado"
                    checked: popup.adapter ? popup.adapter.enabled : false
                    accent: theme.blue
                    onToggled: {
                        if (popup.adapter)
                            popup.adapter.enabled = !popup.adapter.enabled;
                    }
                }
            }

            Text {
                visible: popup.adapter === null
                text: "Nenhum adaptador Bluetooth encontrado"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Text {
                visible: popup.adapter !== null && !popup.adapter.enabled
                text: "Bluetooth desligado"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Text {
                visible: popup.adapter !== null && popup.adapter.enabled && popup.adapter.discovering
                text: "Procurando dispositivos..."
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Flickable {
                visible: popup.adapter !== null && popup.adapter.enabled
                width: popup.contentWidth
                height: Math.min(deviceColumn.implicitHeight, 340)
                contentHeight: deviceColumn.implicitHeight
                clip: true

                Column {
                    id: deviceColumn
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: popup.deviceList()

                        Rectangle {
                            required property var modelData

                            width: deviceColumn.width
                            height: 34
                            radius: 9
                            color: modelData.connected ? Qt.rgba(theme.blue.r, theme.blue.g, theme.blue.b, 0.20) : theme.surface

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
                                    text: "\uf293"
                                    color: modelData.connected ? theme.blue : theme.subtext
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 170
                                    text: modelData.name.length > 0 ? modelData.name : modelData.address
                                    elide: Text.ElideRight
                                    color: theme.text
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                    font.bold: modelData.connected
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: modelData.batteryAvailable
                                    text: Math.round(modelData.battery) + "%"
                                    color: theme.subtext
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize - 1
                                }

                                Item { width: 1; height: 1 }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.connected ? "conectado" : (modelData.paired ? "pareado" : "novo")
                                    color: theme.overlay
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize - 2
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: popup.toggleDevice(modelData)
                            }
                        }
                    }
                }
            }

            ActionButton {
                label: "Abrir bluetoothctl"
                accent: theme.blue
                onClicked: Quickshell.execDetached(["ghostty", "-e", "bluetoothctl"])
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: popup.visible
        onActivated: popup.state.closeAll()
    }
}
