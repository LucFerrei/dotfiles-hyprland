import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: popup

    required property BarState state

    Theme { id: theme }

    property int popupWidth: 340

    readonly property int contentWidth: popup.popupWidth - 24

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    visible: popup.state.calendar
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

    function cells() {
        const date = clock.date;
        const year = date.getFullYear();
        const month = date.getMonth();
        const offset = (new Date(year, month, 1).getDay() + 6) % 7;
        const total = new Date(year, month + 1, 0).getDate();
        const result = [];

        for (let index = 0; index < 42; index++) {
            const day = index - offset + 1;
            result.push({
                day: day,
                current: day >= 1 && day <= total,
                today: day === date.getDate()
            });
        }

        return result;
    }

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
            spacing: 8

            Row {
                width: popup.contentWidth
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf017"
                    color: theme.teal
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize + 3
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDateTime(new Date(clock.date.getFullYear(), clock.date.getMonth(), 1), "MMMM yyyy")
                    color: theme.text
                    font.family: theme.fontFamily
                    font.pixelSize: theme.fontSize + 3
                    font.bold: true
                }
            }

            Row {
                width: popup.contentWidth
                spacing: 2

                Repeater {
                    model: ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"]

                    Text {
                        required property var modelData
                        width: 44
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: theme.overlay
                        font.family: theme.fontFamily
                        font.pixelSize: theme.fontSize - 2
                        font.bold: true
                    }
                }
            }

            Grid {
                columns: 7
                columnSpacing: 2
                rowSpacing: 2

                Repeater {
                    model: popup.cells()

                    Rectangle {
                        required property var modelData

                        width: 44
                        height: 28
                        radius: 8
                        color: modelData.today ? theme.mauve : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData.current ? modelData.day : ""
                            color: modelData.today ? theme.crust : theme.text
                            font.family: theme.fontFamily
                            font.pixelSize: theme.fontSize
                            font.bold: modelData.today
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
