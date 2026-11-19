import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int cpu: 0
    property int memUsed: 0
    property int memTotal: 1
    property int memPercent: 0
    property int temp: 0
    property int brightness: 0

    property real prevTotal: -1
    property real prevIdle: 0

    property Process poll: Process {
        running: false
        command: [
            "bash", "-c",
            "awk '/^cpu /{t=0;for(i=2;i<=NF;i++)t+=$i;print t,$5}' /proc/stat; " +
            "awk '/^MemTotal:/{t=$2}/^MemAvailable:/{a=$2}END{print t,a}' /proc/meminfo; " +
            "cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null || echo 0; " +
            "brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%' || echo 0"
        ]
        stdout: StdioCollector {
            onStreamFinished: root.apply(text)
        }
    }

    property Process brightnessProcess: Process {
        running: false
        onExited: root.refresh()
    }

    property Timer timer: Timer {
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    function refresh() {
        if (!root.poll.running)
            root.poll.running = true;
    }

    function setBrightness(value) {
        const v = Math.max(1, Math.min(100, Math.round(value)));
        root.brightness = v;
        root.brightnessProcess.command = ["brightnessctl", "set", v + "%"];
        root.brightnessProcess.running = true;
    }

    function apply(raw) {
        const lines = raw.trim().split("\n");
        if (lines.length < 2)
            return;

        const cpuParts = lines[0].trim().split(/\s+/).map(Number);
        const memParts = lines[1].trim().split(/\s+/).map(Number);

        const total = cpuParts[0] || 0;
        const idle = cpuParts[1] || 0;

        if (root.prevTotal >= 0 && total > root.prevTotal) {
            const deltaTotal = total - root.prevTotal;
            const deltaIdle = idle - root.prevIdle;
            root.cpu = Math.max(0, Math.min(100, Math.round(100 * (1 - deltaIdle / deltaTotal))));
        }

        root.prevTotal = total;
        root.prevIdle = idle;

        root.memTotal = memParts[0] || 1;
        root.memUsed = Math.max(0, (memParts[0] || 0) - (memParts[1] || 0));
        root.memPercent = Math.round(100 * root.memUsed / root.memTotal);

        if (lines.length > 2)
            root.temp = Math.round((parseInt(lines[2]) || 0) / 1000);
        if (lines.length > 3) {
            const b = parseInt(lines[3]);
            if (!isNaN(b))
                root.brightness = b;
        }
    }
}
