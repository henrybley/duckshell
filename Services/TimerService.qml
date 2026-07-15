pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property list<Item> timers: []

    function getTimer(id) {
        return timers.find(t => t.id === id);
    }

    function addTimer(timer) {
        timers.push(timer);
    }

    function clearTimer(id) {
        let index = timers.findIndex(t => t.id === id);
        if (index >= 0) {
            timers.splice(index, 1);
        }
    }

    property Process dbusMonitor: Process {
        command: ["busctl", "--user", "monitor", "--match=type='signal',interface='org.example.DuckTimer.Out'"]
        running: true

        property string currentMember: ""
        property string currentUuid: ""
        property int lineCount: 0

        stdout: SplitParser {
            onRead: data => {
                let line = data.trim();

                // busctl output format:
                // Line with "Member=" indicates the signal type
                if (line.includes("Member=TimerCreate")) {
                    dbusMonitor.currentMember = "create";
                    dbusMonitor.lineCount = 0;
                } else if (line.includes("Member=TimerTick")) {
                    dbusMonitor.currentMember = "tick";
                    dbusMonitor.lineCount = 0;
                } else if (line.includes("Member=TimerPause")) {
                    dbusMonitor.currentMember = "pause";
                    dbusMonitor.lineCount = 0;
                } else if (line.includes("Member=TimerClear")) {
                    console.log("incoming clear");
                    dbusMonitor.currentMember = "clear";
                    dbusMonitor.lineCount = 0;
                }

                // Parse the MESSAGE section
                if (line.startsWith("MESSAGE")) {
                    dbusMonitor.lineCount = 0;
                } else if (line.startsWith("STRING ")) {
                    // First STRING is the UUID
                    if (dbusMonitor.lineCount === 0) {
                        let id = line.substring(7).replace(/[";]/g, "").trim();
                        dbusMonitor.currentUuid = id;
                        dbusMonitor.lineCount++;
                    }
                    
                    if (dbusMonitor.currentMember === "pause") {
                        handleTimerPause(dbusMonitor.currentUuid);
                    } else if (dbusMonitor.currentMember === "clear") {
                        console.log("clear" + dbusMonitor.currentUuid);
                        handleTimerClear(dbusMonitor.currentUuid);
                    }

                } else if (line.startsWith("UINT64 ")) {
                    // UINT64 is the duration/remaining time
                    let value = parseInt(line.substring(7).replace(/[;]/g, "").trim());
                    let id = dbusMonitor.currentUuid;

                    if (dbusMonitor.currentMember === "create") {
                        handleTimerCreate(id, value, "", "");
                    } else if (dbusMonitor.currentMember === "tick") {
                        handleTimerTick(id, value);
                    }                 }
            }
        }
    }

    function handleTimerCreate(id, duration, name, state) {
        addTimer(timerComponent.createObject(root, {
            timer: {
                id: id,
                name: name,
                duration: duration,
                remaining: duration,
                state: state
            }
        }));
    }

    function handleTimerTick(id, remaining) {
        if (getTimer(id)) {
            getTimer(id).remaining = remaining;
        }
    }

    function handleTimerPause(id) {
        if (getTimer(id)) {
            getTimer(id).state = "paused";
        }
    }

    function handleTimerClear(id) {
        if (getTimer(id)) {
            clearTimer(id);
        }
    }

    // Get all timers
    function getAllTimers() {
        return timers;
    }

    function formatTime(seconds) {
        let hours = Math.floor(seconds / 3600);
        let minutes = Math.floor((seconds % 3600) / 60);
        let secs = seconds % 60;

        let parts = [];

        if (hours > 0) {
            parts.push(`${hours}`);
        }

        if (minutes > 0 || hours > 0) {
            parts.push(`:${minutes}`);
        }

        parts.push(`:${secs}`);

        return parts.join("");
    }

    function callDbusMethod(method, signature, args, callback) {
        // Build command array
        let cmd = ["busctl", "--user", "call", "org.example.DuckTimer", "/org/example/DuckTimer", "org.example.DuckTimer.In", method];

        if (signature) {
            cmd.push(signature);
            cmd = cmd.concat(args);
        }

        let cmdStr = JSON.stringify(cmd);

        let qmlStr = `
            import Quickshell.Io
            Process {
                command: ${cmdStr}
                running: true
                ${callback ? `
                stdout: StdioCollector {
                    onStreamFinished: {
                        callback(this.text);
                    }
                }` : ''}
            }
        `;

        Qt.createQmlObject(qmlStr, root);
    }

    // DBus method calls
    function createTimer(name, durationSecs) {
        callDbusMethod("CreateTimer", "st", [name, durationSecs]);
    }

    function createStartTimer(name, durationSecs) {
        callDbusMethod("CreateStartTimer", "st", [name, durationSecs]);
    }

    function getTimerFromSource(id, callback) {
        callDbusMethod("GetTimer", "s", [id], callback);
    }

    // --- Timer object ---
    Component {
        id: timerComponent
        Item {
            id: timerWrapper

            property var timer
            property string state: "running"
            property string id: ""
            property string name: ""
            property real duration: 0
            property real remaining: 0

            function clear() {
                console.log("called clear");
                root.callDbusMethod("ClearTimer", "s", [timerWrapper.id]);
            }

            function pause() {
                root.callDbusMethod("PauseTimer", "s", [timerWrapper.id]);
            }
            function start() {
                root.callDbusMethod("StartTimer", "s", [timerWrapper.id]);
            }

            Component.onCompleted: {
                if (!timer)
                    return;
                state = timer.state;
                id = timer.id;
                name = timer.name;
                duration = timer.duration;
                remaining = timer.remaining;
                console.log(id);
                console.log(remaining);
            }
        }
    }
}
