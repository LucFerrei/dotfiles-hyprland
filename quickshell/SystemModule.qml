import QtQuick

Rectangle {
    id: root

    required property BarState state
    required property NotificationHub hub

    Theme { id: theme }

    readonly property int notificationCount: root.hub.server ? root.hub.server.trackedNotifications.values.length : 0

    implicitWidth: row.implicitWidth + 18
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Item {
            width: 20
            height: theme.pillHeight

            Text {
                anchors.centerIn: parent
                text: "\uf0f3"
                color: root.hub.dnd ? theme.red : (root.notificationCount > 0 ? theme.yellow : theme.text)
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Text {
                anchors {
                    right: parent.right
                    top: parent.top
                    topMargin: 3
                    rightMargin: -2
                }
                visible: root.notificationCount > 0
                text: root.notificationCount
                color: theme.red
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize - 4
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.state.toggle("notifications")
            }
        }

        Item {
            width: 20
            height: theme.pillHeight

            Text {
                anchors.centerIn: parent
                text: "\uf013"
                color: theme.text
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.state.toggle("control")
            }
        }

        Item {
            width: 20
            height: theme.pillHeight

            Text {
                anchors.centerIn: parent
                text: "\uf011"
                color: theme.maroon
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.state.toggle("power")
            }
        }
    }
}
