@freestanding(expression)
public macro debugLog(_ message: String) = #externalMacro(
    module: "DebugLogMacros",
    type: "DebugLogMacro"
)
