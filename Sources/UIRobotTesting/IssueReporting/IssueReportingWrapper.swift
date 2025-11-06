//
//  IssueReportingWrapper.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//


/// Executes a throwing closure and automatically reports any thrown error as a test issue.
///
/// Use this helper to wrap assertions or operations that may throw. If the `action`
/// completes without throwing, nothing is reported. If it throws, the error is forwarded
/// to the issue reporting system together with the provided source location so that
/// failures are attributed to the correct file and line.
///
/// - Parameters:
///   - sourceLocation: The file and line context that should be associated with a reported failure.
///                     Pass the call-site location so reported issues point to the right place.
///   - action: A closure containing the work that may throw. If it throws, the error is captured
///             and reported; otherwise it is executed normally.
///
/// - Important: This function swallows the thrown error after reporting it. If you need the error
///              to propagate to the caller, do not use this wrapper or rethrow from within `action`.
public func withFailureReport(at sourceLocation: SourceLocation, action: () throws -> Void) {
    do {
        try action()
    } catch {
        Issue.report(error: error, sourceLocation: sourceLocation)
    }
}
