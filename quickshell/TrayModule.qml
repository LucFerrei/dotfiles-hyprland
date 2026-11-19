import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    id: root

    required property var barWindow

    Theme { id: theme }

    visible: SystemTray.items.values.length > 0
    implicitWidth: trayRow.implicitWidth + 16
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill

    function iconSource(name) {
        if (!name || name.length === 0)
            return "";
        if (name.charAt(0) === "/")
            return "file://" + name;
        const path = Quickshell.iconPath(name);
        return path && path.length > 0 ? "file://" + path : "";
    }

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 8

        Repeater {
            model: SystemTray.items.values

            Item {
                required property var modelData

                width: 16
                height: theme.pillHeight

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: 16
                    source: root.iconSource(modelData.icon)
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    cursorShape: Qt.PointingHandCursor
                    onClicked: mouse => {
                        if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                            const point = mapToItem(root.barWindow.contentItem, mouse.x, mouse.y);
                            modelData.display(root.barWindow, point.x, point.y);
                        } else if (mouse.button === Qt.MiddleButton) {
                            modelData.secondaryActivate();
                        } else {
                            modelData.activate();
                        }
                    }
                    onWheel: wheel => modelData.scroll(wheel.angleDelta.y, wheel.angleDelta.x !== 0)
                }
            }
        }
    }
}
