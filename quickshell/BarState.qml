import QtQuick

QtObject {
    id: root

    property bool audio: false
    property bool network: false
    property bool bluetooth: false
    property bool calendar: false
    property bool media: false
    property bool control: false
    property bool notifications: false
    property bool power: false

    function closeAll() {
        root.audio = false;
        root.network = false;
        root.bluetooth = false;
        root.calendar = false;
        root.media = false;
        root.control = false;
        root.notifications = false;
        root.power = false;
    }

    function toggle(name) {
        const wasOpen = root[name];
        root.closeAll();
        if (!wasOpen)
            root[name] = true;
    }

    function open(name) {
        root.closeAll();
        root[name] = true;
    }
}
