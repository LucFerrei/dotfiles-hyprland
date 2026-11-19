import QtQuick
import Quickshell.Services.Notifications

QtObject {
    id: root

    property NotificationServer server: null
    property bool dnd: false
    property var popups: []

    function push(notification) {
        if (!notification || root.dnd)
            return;

        const next = root.popups.slice();
        next.push(notification);
        root.popups = next;
    }

    function remove(notification) {
        root.popups = root.popups.filter(function(item) {
            return item !== notification;
        });
    }

    function clearAll() {
        const list = root.server ? root.server.trackedNotifications.values.slice() : [];
        for (const notification of list)
            notification.dismiss();
        root.popups = [];
    }
}
