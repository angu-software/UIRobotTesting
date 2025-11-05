//
//  IssueReportingWrapper.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//


public func withFailureReport(at sourceLocation: SourceLocation, action: () throws -> Void) {
    do {
        try action()
    } catch {
        Issue.report(error: error, sourceLocation: sourceLocation)
    }
}
