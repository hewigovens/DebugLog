import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(DebugLogMacros)
import DebugLogMacros

let testMacros: [String: Macro.Type] = [
    "debugLog": DebugLogMacro.self,
    "osDebugLog": DebugLogOSLogMacro.self,
]
#endif

final class DebugLogTests: XCTestCase {
    func testMacro() throws {
        #if canImport(DebugLogMacros)
        assertMacroExpansion(
            """
            #debugLog("Test message")
            """,
            expandedSource: #"""
            {
                #if DEBUG
                print("[\(#fileID):\(#line)]", "Test message")
                #endif
            }()
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithVariable() throws {
        #if canImport(DebugLogMacros)
        assertMacroExpansion(
            """
            #debugLog(myVariable)
            """,
            expandedSource: #"""
            {
                #if DEBUG
                print("[\(#fileID):\(#line)]", myVariable)
                #endif
            }()
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testOSLogMacroDefault() throws {
        #if canImport(DebugLogMacros)
        assertMacroExpansion(
            """
            #osDebugLog("Test message")
            """,
            expandedSource: #"""
            {
                #if DEBUG
                if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                    let logger = Logger(
                        subsystem: "DebugLog",
                        category: "default"
                    )
                    logger.debug("[\(#fileID):\(#line)] \("Test message")")
                } else {
                    print("[\(#fileID):\(#line)]", "Test message")
                }
                #endif
            }()
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testOSLogMacroWithCustomParameters() throws {
        #if canImport(DebugLogMacros)
        assertMacroExpansion(
            """
            #osDebugLog("Another", subsystem: "com.example.app", category: "network")
            """,
            expandedSource: #"""
            {
                #if DEBUG
                if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                    let logger = Logger(
                        subsystem: "com.example.app",
                        category: "network"
                    )
                    logger.debug("[\(#fileID):\(#line)] \("Another")")
                } else {
                    print("[\(#fileID):\(#line)]", "Another")
                }
                #endif
            }()
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
