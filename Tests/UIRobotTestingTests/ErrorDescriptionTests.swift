//
//  Test.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 18.09.25.
//

import Testing

@testable import UIRobotTesting

struct ErrorDescriptionTests {

    private let element = UIElementSpec(identifier: "failing-element", scope: .app)
    private let timeout = Timeout.standard

    @Test
    func testNotFoundInViewHierarchy() async throws {
        #expect(UIRobot.Error.notFoundInViewHierarchy(element, timeout).description == "Element 'app.failing-element' was not found in the view hierarchy within 1.0s.")
    }

    @Test
    func testNotHittable() async throws {
        #expect(UIRobot.Error.notHittable(element, timeout).description == "Element 'app.failing-element' was not hittable within 1.0s.")
    }

    @Test
    func testStillPresentInViewHierarchy() async throws {
        #expect(UIRobot.Error.stillPresentInViewHierarchy(element, timeout).description == "Element 'app.failing-element' was still present in the view hierarchy after 1.0s.")
    }

    @Test
    func testConditionTimeout() async throws {
        #expect(UIRobot.Error.conditionTimeout(element, timeout).description == "Condition for element 'app.failing-element' did not resolve within 1.0s.")
    }
}
