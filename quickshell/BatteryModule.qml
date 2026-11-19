import QtQuick
import Quickshell.Services.UPower

Rectangle {
    id: root

    required property BarState state

    Theme { id: theme }

    readonly property var battery: UPower.displayDevice
    readonly property bool charging: root.battery && (root.battery.state === UPowerDeviceState.Charging || root.battery.state === UPowerDeviceState.PendingCharge)
    readonly property bool full: root.battery && root.battery.state === UPowerDeviceState.FullyCharged
    readonly property int percent: root.battery ? Math.round(root.battery.percentage) : 0
    readonly property bool low: root.percent <= 15 && !root.charging

    visible: root.battery !== null && root.battery.isPresent
    implicitWidth: content.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: root.charging || root.full ? theme.green : (root.low ? theme.red : theme.pill)

    function batteryIcon() {
        if (root.charging)
            return "\uf0e7";
        if (root.percent > 90)
            return "\uf240";
        if (root.percent > 65)
            return "\uf241";
        if (root.percent > 40)
            return "\uf242";
        if (root.percent > 15)
            return "\uf243";
        return "\uf244";
    }

    function remaining() {
        if (!root.battery || root.battery.timeToEmpty <= 0)
            return "";
        const total = Math.round(root.battery.timeToEmpty / 60);
        const hours = Math.floor(total / 60);
        const minutes = total % 60;
        return hours + ":" + (minutes < 10 ? "0" : "") + minutes;
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.batteryIcon()
            color: root.charging || root.full || root.low ? theme.crust : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.percent + "%"
            color: root.charging || root.full || root.low ? theme.crust : theme.text
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize
            font.bold: true
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: !root.charging && root.remaining().length > 0
            text: root.remaining()
            color: root.low ? theme.crust : theme.subtext
            font.family: theme.fontFamily
            font.pixelSize: theme.fontSize - 1
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                root.state.toggle("power");
            else
                root.state.toggle("control");
        }
    }
}
