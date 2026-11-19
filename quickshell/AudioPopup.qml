import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

PanelWindow {
    id: popup

    required property BarState state

    Theme { id: theme }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property int contentWidth: popup.popupWidth - 24
    property int popupWidth: 360

    visible: popup.state.audio
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
                text: "Áudio"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize + 3
                font.bold: true
            }

            Text {
                text: "Saída"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                spacing: 8
                width: popup.contentWidth

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.sink ? (popup.sink.description.length > 0 ? popup.sink.description : popup.sink.name) : "sem saída"
                    width: popup.contentWidth - 60
                    elide: Text.ElideRight
                    color: theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.sink && popup.sink.audio ? Math.round(popup.sink.audio.volume * 100) + "%" : "--"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }
            }

            Row {
                spacing: 8
                width: popup.contentWidth

                Slider {
                    width: popup.contentWidth - 52
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
            }

            Rectangle {
                width: popup.contentWidth
                height: 1
                color: theme.outline
            }

            Text {
                text: "Entrada"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                spacing: 8
                width: popup.contentWidth

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.source ? (popup.source.description.length > 0 ? popup.source.description : popup.source.name) : "sem entrada"
                    width: popup.contentWidth - 60
                    elide: Text.ElideRight
                    color: theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: popup.source && popup.source.audio ? Math.round(popup.source.audio.volume * 100) + "%" : "--"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize
                }
            }

            Row {
                spacing: 8
                width: popup.contentWidth

                Slider {
                    width: popup.contentWidth - 52
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
            }

            Rectangle {
                width: popup.contentWidth
                height: 1
                color: theme.outline
            }

            Text {
                text: "Aplicativos"
                color: theme.subtext
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Repeater {
                model: Pipewire.nodes.values.filter(function(node) {
                    return node.isStream && node.audio !== null;
                })

                Row {
                    required property var modelData

                    width: popup.contentWidth
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.description.length > 0 ? modelData.description : modelData.name
                        width: 110
                        elide: Text.ElideRight
                        color: theme.text
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }

                    Slider {
                        anchors.verticalCenter: parent.verticalCenter
                        width: popup.contentWidth - 150
                        value: modelData.audio ? modelData.audio.volume : 0
                        from: 0
                        to: 1.5
                        fillColor: theme.mauve
                        onMoved: value => {
                            if (modelData.audio)
                                modelData.audio.volume = value;
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.audio && modelData.audio.muted ? "\uf026" : "\uf028"
                        color: modelData.audio && modelData.audio.muted ? theme.red : theme.text
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.audio)
                                    modelData.audio.muted = !modelData.audio.muted;
                            }
                        }
                    }
                }
            }

            Text {
                visible: Pipewire.nodes.values.filter(function(node) {
                    return node.isStream && node.audio !== null;
                }).length === 0
                text: "Nenhum aplicativo tocando"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            ActionButton {
                label: "Abrir pavucontrol"
                accent: theme.blue
                onClicked: Quickshell.execDetached(["pavucontrol"])
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: popup.visible
        onActivated: popup.state.closeAll()
    }
}
