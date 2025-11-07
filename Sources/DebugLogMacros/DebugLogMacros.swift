import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DebugLogMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return #"""
        {
            #if DEBUG
            print("[\(#fileID):\(#line)]", \#(argument))
            #endif
        }()
        """#
    }
}

public struct OSLogDebugMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let messageArgument = node.arguments.first(where: { $0.label == nil })?.expression.trimmed else {
            fatalError("compiler bug: the macro does not have a message argument")
        }

        let subsystemArgument = node.arguments.first(where: { $0.label?.text == "subsystem" })?.expression.trimmed
        let categoryArgument = node.arguments.first(where: { $0.label?.text == "category" })?.expression.trimmed

        let defaultSubsystem: ExprSyntax = #""DebugLog""#
        let defaultCategory: ExprSyntax = #""default""#

        return #"""
        {
            #if DEBUG
            if #available(macOS 11, iOS 14, tvOS 14, watchOS 7, *) {
                let logger = Logger(
                    subsystem: \#(subsystemArgument ?? defaultSubsystem),
                    category: \#(categoryArgument ?? defaultCategory)
                )
                logger.debug("[\(#fileID):\(#line)] \(\#(messageArgument))")
            } else {
                print("[\(#fileID):\(#line)]", \#(messageArgument))
            }
            #endif
        }()
        """#
    }
}

@main
struct DebugLogPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DebugLogMacro.self,
        OSLogDebugMacro.self,
    ]
}
