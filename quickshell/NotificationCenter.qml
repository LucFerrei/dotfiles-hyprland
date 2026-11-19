import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

PanelWindow {
    id: popup

    required property BarState state
    required property NotificationHub hub
    required property NotificationServer server

    Theme { id: theme }

    property int popupWidth: 360

    readonly property int contentWidth: popup.popupWidth - 24
    readonly property int count: popup.server ? popup.server.trackedNotifications.values.length : 0

    visible: popup.state.notifications
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusiveZone: 0
    aboveWindows: true
    focusable: true
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-popup"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    MouseArea {
        anchors.fill: parent
        onClicked: popup.state.closeAll()
    }

    Rectangle {
        id: panel
        anchors {
            top: parent.top
            right: parent.right
            topMargin: theme.popupTopMargin
            rightMargin: 8
        }
        width: popup.popupWidth
        implicitHeight: content.implicitHeight + 24
        radius: 14
        color: theme.panel
        border.width: 1
        border.color: theme.outline

        MouseArea {
            anchors.fill: parent
        }

        Column {
            id: content
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 9

            Item {
                width: popup.contentWidth
                height: 30

                Text {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Notificações (" + popup.count + ")"
                    color: theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize + 3
                    font.bold: true
                }

                Row {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 6

                    ToggleButton {
                        label: "DND"
                        checked: popup.hub.dnd
                        accent: theme.red
                        onToggled: popup.hub.dnd = !popup.hub.dnd
                    }

                    ActionButton {
                        label: "Limpar"
                        accent: theme.maroon
                        onClicked: popup.hub.clearAll()
                    }
                }
            }

            Text {
                visible: popup.count === 0
                text: "Nenhuma notificação"
                color: theme.overlay
                font.family: theme.fontFamily
                font.pixelSize: theme.fontSize
            }

            Flickable {
                visible: popup.count > 0
                width: popup.contentWidth
                height: Math.min(notificationColumn.implicitHeight, 400)
                contentHeight: notificationColumn.implicitHeight
                clip: true

                Column {
                    id: notificationColumn
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: popup.server ? popup.server.trackedNotifications.values : []

                        Rectangle {
                            required property var modelData

                            width: notificationColumn.width
                            implicitHeight: card.implicitHeight + 20
                            radius: 10
                            color: theme.surface

                            Column {
                                id: card
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    top: parent.top
                                    margins: 10
                                }
                                spacing: 3

                                Item {
                                    width: card.width
                                    height: appName.implicitHeight

                                    Text {
                                        id: appName
                                        anchors {
                                            left: parent.left
                                            right: closeButton.left
                                            rightMargin: 6
                                        }
                                        text: modelData.appName.length > 0 ? modelData.appName : "Notificação"
                                        elide: Text.ElideRight
                                        color: theme.overlay
                                        font.family: theme.fontFamily
                                        font.pixelSize: theme.fontSize - 2
                                    }

                                    Text {
                                        id: closeButton
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
                                            onClicked: modelData.dismiss()
                                        }
                                    }
                                }

                                Text {
                                    width: card.width
                                    text: modelData.summary
                                    wrapMode: Text.Wrap
                                    color: theme.text
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                    font.bold: true
                                }

                                Text {
                                    width: card.width
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
                        }
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: popup.visible
        onActivated: popup.state.closeAll()
    }
}
