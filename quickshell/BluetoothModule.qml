import QtQuick
import Quickshell.Bluetooth

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var connectedDevice: {
        if (!root.adapter)
            return null;
        for (const device of root.adapter.devices.values) {
            if (device.connected)
                return device;
        }
        return null;
    }

    visible: root.adapter !== null
    implicitWidth: row.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill
    opacity: root.adapter && root.adapter.enabled ? 1.0 : 0.55

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf293"
            color: root.connectedDevice ? theme.blue : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.connectedDevice !== null && root.connectedDevice.batteryAvailable
            text: root.connectedDevice && root.connectedDevice.batteryAvailable ? Math.round(root.connectedDevice.battery) + "%" : ""
            color: theme.subtext
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize - 1
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton && root.adapter)
                root.adapter.enabled = !root.adapter.enabled;
            else
                root.state.toggle("bluetooth");
        }
    }
}
