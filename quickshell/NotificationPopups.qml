import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

PanelWindow {
    id: root

    required property NotificationHub hub
    required property var targetScreen
    required property Compositor compositor

    Theme { id: theme }

    implicitWidth: 360
    implicitHeight: column.implicitHeight
    color: "transparent"
    anchors {
        top: true
        right: true
    }
    margins {
        top: 44
        right: 8
    }
    exclusiveZone: 0
    aboveWindows: true
    focusable: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-notifications"

    visible: root.hub.popups.length > 0 && root.focused()

    function focused() {
        const monitor = root.compositor.focusedMonitorName;
        return monitor.length > 0 && root.targetScreen !== null && monitor === root.targetScreen.name;
    }

    Column {
        id: column
        width: parent.width
        spacing: 8

        Repeater {
            model: root.hub.popups

            Rectangle {
                id: card

                required property var modelData

                width: column.width
                implicitHeight: cardContent.implicitHeight + 20
                radius: 12
                color: theme.panel
                border.width: 1
                border.color: modelData.urgency === NotificationUrgency.Critical ? theme.red : theme.outline

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (modelData.actions.length > 0)
                            modelData.actions[0].invoke();
                        root.hub.remove(modelData);
                    }
                }

                Column {
                    id: cardContent
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 10
                    }
                    spacing: 3

                    Item {
                        width: cardContent.width
                        height: headerText.implicitHeight

                        Text {
                            id: headerText
                            anchors {
                                left: parent.left
                                right: closeText.left
                                rightMargin: 6
                            }
                            text: modelData.appName.length > 0 ? modelData.appName : "Notificação"
                            elide: Text.ElideRight
                            color: theme.overlay
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize - 2
                        }

                        Text {
                            id: closeText
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                            text: "×"
                            color: theme.overlay
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize + 2

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.hub.remove(modelData)
                            }
                        }
                    }

                    Text {
                        width: cardContent.width
                        text: modelData.summary
                        wrapMode: Text.Wrap
                        color: theme.text
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                        font.bold: true
                    }

                    Text {
                        width: cardContent.width
                        visible: modelData.body.length > 0
                        text: modelData.body
                        wrapMode: Text.Wrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                        color: theme.subtext
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize
                    }
                }

                Timer {
                    interval: modelData.expireTimeout > 0 ? modelData.expireTimeout : 5000
                    running: modelData.urgency !== NotificationUrgency.Critical
                    onTriggered: root.hub.remove(modelData)
                }
            }
        }
    }
}
