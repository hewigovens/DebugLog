import DebugLog
import OSLogDebugMacro

let sampleUsernames = ["ana", "ben", "cora"]
#debugLog("Loaded \(sampleUsernames.count) users: \(sampleUsernames)")

#osDebugLog(
    "Finished syncing profiles",
    subsystem: "com.example.DebugLogClient",
    category: "sync"
)
