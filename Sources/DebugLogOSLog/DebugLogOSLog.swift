@_exported import OSLog

@freestanding(expression)
public macro osDebugLog(
    _ message: String,
    subsystem: String = "DebugLog",
    category: String = "default"
) = #externalMacro(
    module: "DebugLogMacros",
    type: "DebugLogOSLogMacro"
)
