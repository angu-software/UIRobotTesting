//
//  SourceLocationMacro.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

import SwiftSyntax
import SwiftSyntaxMacros

package struct SourceLocationMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax,
                                 in context: some MacroExpansionContext) throws -> ExprSyntax {
        return "UIRobotTesting.SourceLocation.__here()"
    }
}
