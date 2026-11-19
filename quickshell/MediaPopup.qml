import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

PanelWindow {
    id: popup

    required property BarState state

    Theme { id: theme }

    property int popupWidth: 340

    readonly property int contentWidth: popup.popupWidth - 24
    readonly property var player: {
        const players = Mpris.players.values;
        for (const candidate of players) {
            if (candidate.isPlaying)
                return candidate;
        }
        return players.length > 0 ? players[0] : null;
    }

    visible: popup.state.media
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

    function timeText(seconds) {
        const total = Math.max(0, Math.round(seconds || 0));
        const minutes = Math.floor(total / 60);
        const rest = total % 60;
        return minutes + ":" + (rest < 10 ? "0" : "") + rest;
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

            Text {
                text: "Reprodutor"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize + 3
                font.bold: true
            }

            Text {
                visible: popup.player === null
                text: "Nenhum reprodutor ativo"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Row {
                visible: popup.player !== null
                width: popup.contentWidth
                spacing: 10

                Rectangle {
                    width: 64
                    height: 64
                    radius: 10
                    color: theme.surface

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: popup.player ? popup.player.trackArtUrl : ""
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: !popup.player || popup.player.trackArtUrl.length === 0
                        text: "\uf001"
                        color: theme.overlay
                        font.family: theme.fontFamily
                        font.pixelSize: 24
                    }
                }

                Column {
                    width: popup.contentWidth - 74
                    spacing: 2

                    Text {
                        width: parent.width
                        text: popup.player ? popup.player.trackTitle : ""
                        elide: Text.ElideRight
                        color: theme.text
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize + 1
                        font.bold: true
                    }

                    Text {
                        width: parent.width
                        text: popup.player ? popup.player.trackArtist : ""
                        elide: Text.ElideRight
                        color: theme.subtext
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }

                    Text {
                        width: parent.width
                        text: popup.player ? popup.player.trackAlbum : ""
                        elide: Text.ElideRight
                        color: theme.overlay
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize - 1
                    }
                }
            }

            Slider {
                visible: popup.player !== null
                width: popup.contentWidth
                value: popup.player && popup.player.length > 0 ? popup.player.position / popup.player.length : 0
                from: 0
                to: 1
                fillColor: theme.mauve
                onMoved: value => {
                    if (popup.player && popup.player.canSeek && popup.player.length > 0)
                        popup.player.seek(value * popup.player.length - popup.player.position);
                }
            }

            Row {
                visible: popup.player !== null
                width: popup.contentWidth

                Text {
                    text: popup.player ? popup.timeText(popup.player.position) : "0:00"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize - 1
                }

                Item { width: popup.contentWidth - 90; height: 1 }

                Text {
                    text: popup.player ? popup.timeText(popup.player.length) : "0:00"
                    color: theme.subtext
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize - 1
                }
            }

            Row {
                visible: popup.player !== null
                width: popup.contentWidth
                spacing: 8

                ActionButton {
                    label: "\uf048"
                    accent: theme.text
                    onClicked: {
                        if (popup.player)
                            popup.player.previous();
                    }
                }

                ActionButton {
                    label: popup.player && popup.player.isPlaying ? "\uf04c" : "\uf04b"
                    accent: theme.green
                    onClicked: {
                        if (popup.player)
                            popup.player.togglePlaying();
                    }
                }

                ActionButton {
                    label: "\uf051"
                    accent: theme.text
                    onClicked: {
                        if (popup.player)
                            popup.player.next();
                    }
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
