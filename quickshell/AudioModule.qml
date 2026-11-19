import QtQuick
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource
    readonly property var audio: root.sink ? root.sink.audio : null
    readonly property var mic: root.source ? root.source.audio : null
    readonly property bool muted: root.audio ? root.audio.muted : false

    implicitWidth: row.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: root.muted ? theme.red : theme.pill

    function volumeIcon() {
        if (!root.audio || root.audio.muted)
            return "\uf026";
        if (root.audio.volume < 0.34)
            return "\uf027";
        if (root.audio.volume < 0.67)
            return "\uf027";
        return "\uf028";
    }

    function change(delta) {
        if (!root.audio)
            return;
        const next = Math.max(0, Math.min(1.5, root.audio.volume + delta));
        root.audio.volume = next;
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.volumeIcon()
            color: root.muted ? theme.crust : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.audio ? Math.round(root.audio.volume * 100) + "%" : "--"
            color: root.muted ? theme.crust : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
            font.bold: true
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.mic ? root.mic.muted : false
            text: "\uf131"
            color: theme.crust
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                if (root.audio)
                    root.audio.muted = !root.audio.muted;
            } else {
                root.state.toggle("audio");
            }
        }
        onWheel: wheel => root.change(wheel.angleDelta.y > 0 ? 0.05 : -0.05)
    }
}
