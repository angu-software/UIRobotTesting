//
//  SourceLocation+Macro.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

@freestanding(expression)
public macro source_location() -> SourceLocation = #externalMacro(module: "UIRobotMacros", type: "SourceLocationMacro")

extension SourceLocation {
    /// Get the current source location as an instance of ``SourceLocation``.
    ///
    /// - Warning: This function is used to implement the `#source_location`
    ///   macro. Do not call it directly.
    public static func __here(
        filePath: StaticString = #filePath,
        line: UInt = #line
    ) -> Self {
        Self(filePath: filePath, line: line)
    }
}
