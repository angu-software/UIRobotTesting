//
//  SourceLocation+Macro.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

/// Returns a `SourceLocation` describing the call site where the macro is expanded.
///
/// The macro eliminates the need to manually passing `#filePath` / `#line` through robot layers and
/// standardizes how locations are captured across all robot APIs
///
/// Use `#source_location()` to tag robot APIs with its
/// originating test file and line. This ensures failure reports to point to the test code that initiated the interaction.
///
/// Primary uses in this project:
/// - Used to generate failure reports using ``withFailureReport(at:)
///
/// ## Example
///
/// ```swift
/// final class MyRobot: UIRobot {
///
///   // #source_location is expanded at call site containing the call sites source location information
///   func tabButton(sourceLocation: SourceLocation = #source_location) {
///
///       // Uses the source location to generate an failure issue which will point to the call site to report the issue
///       withFailureReport(at: sourceLocation) {
///           let button = root.descendant("button")
///           try tap(button)
///       }
///   }
/// }
/// robot.tap(button: "Login", at: #source_location())
/// robot.expect(label: "Welcome", toHaveText: "Hello", at: #source_location())
/// ```
///
/// - Returns: A `SourceLocation` of the test call site for inclusion in robot APIs.
@freestanding(expression)
public macro source_location() -> SourceLocation =
    #externalMacro(module: "UIRobotMacros", type: "SourceLocationMacro")

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
