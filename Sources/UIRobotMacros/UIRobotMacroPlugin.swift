//
//  UIRobotMacroPlugin.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct UIRobotMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SourceLocationMacro.self,
    ]
}
