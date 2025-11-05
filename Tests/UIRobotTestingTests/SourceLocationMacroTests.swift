//
//  SourceLocationMacroTests.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

import Testing

import UIRobotTesting

struct SourceLocationMacroTests {

    @Test
    func defaultSourceLocationShouldResolveToCallSiteSourceLocation() {
        #expect(testFunc() == "\(#filePath):\(#line)")
    }

    func testFunc(sourceLocation: UIRobotTesting.SourceLocation = #source_location) -> String {
        return "\(sourceLocation.filePath):\(sourceLocation.line)"
    }
}
