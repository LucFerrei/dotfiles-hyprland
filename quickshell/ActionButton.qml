import QtQuick

Rectangle {
    id: root

    property string label: ""
    property color accent: theme.text
    property int horizontalPadding: 14

    signal clicked()

    Theme { id: theme }

    implicitWidth: labelText.implicitWidth + root.horizontalPadding * 2
    implicitHeight: 30
    radius: 9
    color: theme.surface
    border.width: 1
    border.color: theme.outline

    Text {
        id: labelText
        anchors.centerIn: parent
        text: root.label
        color: root.accent
        font.family: theme.fontFamily
        font.pixelSize: theme.fontSize
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
