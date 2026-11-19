import QtQuick
import Quickshell.Networking

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    readonly property var wifiDevice: {
        for (const device of Networking.devices.values) {
            if (device.type === DeviceType.Wifi)
                return device;
        }
        return null;
    }

    readonly property var wifiNetwork: {
        if (!root.wifiDevice)
            return null;
        for (const network of root.wifiDevice.networks.values) {
            if (network.connected)
                return network;
        }
        return null;
    }

    readonly property var wiredDevice: {
        for (const device of Networking.devices.values) {
            if (device.type === DeviceType.Wired && device.connected)
                return device;
        }
        return null;
    }

    readonly property bool wifiAvailable: root.wifiDevice !== null

    implicitWidth: row.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill
    opacity: (root.wifiAvailable && Networking.wifiEnabled) || root.wiredDevice ? 1.0 : 0.6

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.wiredDevice ? "\uf0ac" : (Networking.wifiEnabled ? "\uf1eb" : "\uf00d")
            color: root.wiredDevice || root.wifiNetwork ? theme.green : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: 90
            text: root.wiredDevice ? "eth" : (root.wifiNetwork ? root.wifiNetwork.name : (root.wifiAvailable ? "wifi" : "sem rede"))
            elide: Text.ElideRight
            color: theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Networking.wifiEnabled = !Networking.wifiEnabled;
            else
                root.state.toggle("network");
        }
    }
}
