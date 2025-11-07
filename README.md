# DebugLog

Tiny Swift macro package that turns `#debugLog(...)` invocations into `print` statements that include the originating `#fileID` and `#line`. The macro expansion is wrapped in `#if DEBUG`, so it only emits logs in debug builds and compiles away everywhere else.

## Targets & Usage

### `DebugLog` (print-based)

1. Add the package as a dependency to your app target.
2. Import `DebugLog`.
3. Call `#debugLog("Something to inspect")` or pass any expression, e.g. `#debugLog(userState)`.

The macro expands to:

```swift
{
    #if DEBUG
    print("[<file>:<line>]", <expression>)
    #endif
}()
```

### `OSLogDebugMacro` (Unified Logging)

If you prefer the unified logging system, depend on and import `OSLogDebugMacro` instead. Use `#osDebugLog`:

```swift
#osDebugLog("Network response", subsystem: "com.acme.app", category: "networking")
```

Expansion:

```swift
{
    #if DEBUG
    if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
        let logger = Logger(subsystem: "com.acme.app", category: "networking")
        logger.debug("[<file>:<line>] \(message)")
    } else {
        print("[<file>:<line>]", message)
    }
    #endif
}()
```

Subsystem and category default to `"DebugLog"` / `"default"` when omitted. The generated code automatically falls back to `print` on older OSes, so you can use the macro in shared targets without additional guards.

## Development

Run the unit tests to ensure the macro still expands as expected:

```bash
swift test
```

If you tweak the emitted code (e.g., to add timestamps or different formatting), update the expected expansion strings in `Tests/DebugLogTests/DebugLogTests.swift` so the tests continue to pass.

You can also run the tiny demo client to see both macros in action:

```bash
swift run DebugLogClient
```

