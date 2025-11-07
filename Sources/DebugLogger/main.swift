import DebugLog
import DebugLogOSLog

let sampleUsernames = ["ana", "ben", "cora"]
#debugLog("Loaded \(sampleUsernames.count) users: \(sampleUsernames)")

#osDebugLog(
    "Finished syncing profiles",
    subsystem: "com.example.DebugLogger",
    category: "sync"
)
