import QtQuick
import Quickshell

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    implicitWidth: content.implicitWidth + 18
    implicitHeight: theme.pillHeight
    radius: theme.radius
    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: theme.teal }
        GradientStop { position: 1.0; color: theme.blue }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 6

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf017"
            color: theme.crust
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDateTime(clock.date, "dd MMM, HH:mm")
            color: theme.crust
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.state.toggle("calendar")
    }
}
