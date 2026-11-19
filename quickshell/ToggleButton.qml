import QtQuick

Rectangle {
    id: root

    property string label: ""
    property bool checked: false
    property color accent: theme.green

    signal toggled()

    Theme { id: theme }

    implicitWidth: labelText.implicitWidth + 28
    implicitHeight: 30
    radius: 9
    color: root.checked ? Qt.rgba(root.accent.r, root.accent.g, root.accent.b, 0.28) : theme.surface
    border.width: 1
    border.color: root.checked ? root.accent : theme.outline

    Text {
        id: labelText
        anchors.centerIn: parent
        text: root.label
        color: root.checked ? root.accent : theme.text
        font.family: theme.fontFamily
        font.pixelSize: theme.fontSize
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
