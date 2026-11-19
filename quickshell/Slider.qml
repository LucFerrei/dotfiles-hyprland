import QtQuick

Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 1
    property color fillColor: "#a6e3a1"
    property color trackColor: "#45475a"
    property int trackHeight: 6

    signal moved(real value)

    implicitHeight: 22
    implicitWidth: 160

    readonly property real ratio: root.to > root.from ? Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from))) : 0

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: root.trackHeight
        radius: height / 2
        color: root.trackColor
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: Math.max(height, track.width * root.ratio)
        height: root.trackHeight
        radius: height / 2
        color: root.fillColor
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: Math.min(track.width - width, Math.max(0, track.width * root.ratio - width / 2))
        width: 13
        height: 13
        radius: 7
        color: "#cdd6f4"
    }

    MouseArea {
        anchors.fill: parent

        function apply(x) {
            const clamped = Math.max(0, Math.min(1, x / width));
            root.moved(root.from + clamped * (root.to - root.from));
        }

        onPressed: mouse => apply(mouse.x)
        onPositionChanged: mouse => {
            if (pressed)
                apply(mouse.x);
        }
        onWheel: wheel => {
            const step = (root.to - root.from) * 0.05;
            const next = Math.max(root.from, Math.min(root.to, root.value + (wheel.angleDelta.y > 0 ? step : -step)));
            root.moved(next);
        }
    }
}
