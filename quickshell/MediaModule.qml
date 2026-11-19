import QtQuick
import Quickshell.Services.Mpris

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    readonly property var player: {
        const players = Mpris.players.values;
        for (const candidate of players) {
            if (candidate.isPlaying)
                return candidate;
        }
        return players.length > 0 ? players[0] : null;
    }

    visible: root.player !== null
    implicitWidth: content.implicitWidth + 18
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill
    clip: true

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 6

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.player && root.player.isPlaying ? "\uf04c" : "\uf04b"
            color: root.player && root.player.isPlaying ? theme.green : theme.subtext
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: 150
            text: root.player ? (root.player.trackTitle.length > 0 ? root.player.trackTitle : root.player.identity) : ""
            elide: Text.ElideRight
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton && root.player)
                root.player.togglePlaying();
            else
                root.state.toggle("media");
        }
    }
}
