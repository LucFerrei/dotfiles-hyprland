import QtQuick
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root

    visible: root.title.length > 0

    Theme { id: theme }

    readonly property string title: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""

    implicitWidth: Math.min(260, label.implicitWidth) + 22
    implicitHeight: theme.pillHeight
    radius: theme.radius
    color: theme.pill

    Text {
        id: label
        anchors.centerIn: parent
        width: Math.min(240, implicitWidth)
        text: root.title
        elide: Text.ElideRight
        color: theme.subtext
        font.family: theme.fontFamily
        font.pixelSize: theme.fontSize
    }
}
