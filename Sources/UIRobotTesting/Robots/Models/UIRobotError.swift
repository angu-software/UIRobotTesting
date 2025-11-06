//
//  Error.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 18.09.25.
//


extension UIRobot {

    public enum Error: Swift.Error {
        case notFoundInViewHierarchy(UIElementSpec, Timeout)
        case notHittable(UIElementSpec, Timeout)
        case stillPresentInViewHierarchy(UIElementSpec, Timeout)
        case conditionTimeout(UIElementSpec, Timeout)
    }
}

extension UIRobot.Error: CustomStringConvertible {

    public var description: String {
        switch self {
        case let .notFoundInViewHierarchy(spec, timeout):
                return "Element '\(spec.hierarchyPath)' was not found in the view hierarchy within \(timeout)s."
        case let .notHittable(spec, timeout):
                return "Element '\(spec.hierarchyPath)' was not hittable within \(timeout)s."
        case let .stillPresentInViewHierarchy(spec, timeout):
                return "Element '\(spec.hierarchyPath)' was still present in the view hierarchy after \(timeout)s."
        case let .conditionTimeout(spec, timeout):
                return "Condition for element '\(spec.hierarchyPath)' did not resolve within \(timeout)s."
        }
    }
}
