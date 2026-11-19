import QtQuick

Rectangle {
    id: root

    required property SysStats stats

    Theme { id: theme }

    implicitWidth: row.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 9

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf2db " + root.stats.cpu + "%"
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf538 " + (Math.round(root.stats.memUsed / 1048576 * 10) / 10) + "G"
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf2c7 " + root.stats.temp + "°C"
            color: root.stats.temp >= 80 ? theme.red : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }
    }
}
