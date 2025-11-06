//
//  Issue.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 03.09.25.
//

import XCTest

/// Utility for handling test failures and issues in a structured way.
///
/// Provides convenience methods to report errors or record issues
public enum Issue {

    /// Reports a test failure for the given error at the specified source location.
    ///
    /// - Parameters:
    ///   - error: The error that caused the failure. Its description will be included
    ///     in the failure message.
    ///   - sourceLocation: The location of the source file in which the failure occurred
    public static func report(error: Error, sourceLocation: SourceLocation) {
        XCTFail("\(error)", file: sourceLocation.filePath, line: sourceLocation.line)
    }
}
