//
//  UIElementSpec.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 25.08.25.
//

import XCTest

/// Defines the scope in which a UI element is searched.
public indirect enum UIElementScope: Equatable, Sendable {

    /// The element is searched at the application level.
    case app

    /// The element is searched as a descendant of another element spec.
    case descendantOf(UIElementSpec)
}

/// A declarative specification of a UI element for locating it in tests.
public struct UIElementSpec: Equatable, Sendable {

    /// The type of the UI element (e.g., button, staticText, any).
    public typealias ElementType = XCUIElement.ElementType

    /// The search scope of the element.
    public typealias ElementScope = UIElementScope

    /// The accessibility identifier of the element.
    public let identifier: String

    /// The type of the element.
    public let type: ElementType

    /// The scope where the element is to be searched.
    public let scope: ElementScope

    /// Creates a new element specification.
    ///
    /// - Parameters:
    ///   - identifier: The accessibility identifier of the element.
    ///   - type: The type of the element. Defaults to `.any`.
    ///   - scope: The scope in which to search for the element.
    public init(identifier: String, type: ElementType = .any, scope: ElementScope) {
        self.identifier = identifier
        self.type = type
        self.scope = scope
    }

    /// Returns a new spec representing a descendant of this element.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the descendant element.
    ///   - type: The type of the descendant element. Defaults to `.any`.
    /// - Returns: A `UIElementSpec` representing the descendant.
    public func descendant(_ identifier: String, ofType type: ElementType = .any) -> Self {
        return Self.init(identifier: identifier, type: type, scope: .descendantOf(self))
    }
}
