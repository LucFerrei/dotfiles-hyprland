import QtQuick

QtObject {
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
    readonly property int barHeight: 36
    readonly property int pillHeight: 28
    readonly property int radius: 10
    readonly property int gap: 5
    readonly property int popupTopMargin: 44

    readonly property color crust: "#11111b"
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color surface: "#313244"
    readonly property color text: "#cdd6f4"
    readonly property color subtext: "#a6adc8"
    readonly property color overlay: "#6c7086"
    readonly property color outline: "#45475a"

    readonly property color pink: "#f5c2e7"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"
    readonly property color maroon: "#eba0ac"
    readonly property color peach: "#fab387"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color teal: "#94e2d5"
    readonly property color sky: "#89dceb"
    readonly property color blue: "#89b4fa"
    readonly property color lavender: "#b4befe"

    readonly property color pill: Qt.rgba(21 / 255, 18 / 255, 27 / 255, 0.72)
    readonly property color panel: Qt.rgba(24 / 255, 24 / 255, 37 / 255, 0.97)
    readonly property color scrim: Qt.rgba(17 / 255, 17 / 255, 27 / 255, 0.35)
}
