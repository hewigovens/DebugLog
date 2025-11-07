// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "DebugLog",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [
        .library(
            name: "DebugLog",
            targets: ["DebugLog"]
        ),
        .library(
            name: "OSLogDebug",
            targets: ["OSLogDebug"]
        ),
        .executable(
            name: "DebugLogClient",
            targets: ["DebugLogClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "602.0.0"),
    ],
    targets: [
        .macro(
            name: "DebugLogMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(
            name: "DebugLog",
            dependencies: ["DebugLogMacros"]
        ),
        .target(
            name: "OSLogDebug",
            dependencies: ["DebugLogMacros"]
        ),

        .executableTarget(
            name: "DebugLogClient",
            dependencies: ["DebugLog", "OSLogDebug"]
        ),

        .testTarget(
            name: "DebugLogTests",
            dependencies: [
                "DebugLogMacros",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
