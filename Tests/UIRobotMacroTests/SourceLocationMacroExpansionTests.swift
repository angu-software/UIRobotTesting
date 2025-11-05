//
//  SourceLocationMacroExpansionTests.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UIRobotMacros)
import UIRobotMacros
#endif

final class SourceLocationMacroExpansionTests: XCTestCase {

    private var testMacros: [String: Macro.Type] = [:]

    override func setUp() async throws {
        try await super.setUp()

#if canImport(UIRobotMacros)
        testMacros = [
            "source_location": SourceLocationMacro.self,
        ]
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func test_it_expand_SourceLocation_here() throws {
        assertMacroExpansion(
                #"""
                #source_location
                """#,
                expandedSource: #"""
                UIRobotTesting.SourceLocation.__here()
                """#,
                macros: testMacros
        )
    }

    func test_when_part_of_an_method_signature_it_expand_SourceLocation_here() throws {
        assertMacroExpansion(
                #"""
                func test(sourceLocation: SourceLocation = #source_location)
                """#,
                expandedSource: #"""
                func test(sourceLocation: SourceLocation = UIRobotTesting.SourceLocation.__here())
                """#,
                macros: testMacros
        )
    }
}
