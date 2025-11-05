//
//  XCUIElement+ExistenceChecks.swift
//  Pandocs
//
//  Created by Andreas Günther on 07.07.25.
//

import XCTest

extension XCUIElement {

    // TODO: remove default value
    // TODO: hide behind UIRobot API
    public func exists(after timeout: TimeInterval = 1) -> Bool {
        return exists || waitForExistence(timeout: timeout)
    }

    public func notExists(after timeout: TimeInterval = 1) -> Bool {
        return !exists || waitForNonExistence(timeout: timeout)
    }

    public func isHittable(after timeout: TimeInterval = 1) -> Bool {
        return isHittable || waitToBeHittable(timeout: timeout)
    }

    public func waitToBeHittable(timeout: TimeInterval = 1) -> Bool {
        let predicate = NSPredicate(format: "hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)

        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)

        return result == .completed
    }
}
