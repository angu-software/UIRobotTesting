//
//  UIRobot.swift
//  Pandocs
//
//  Created by Andreas Günther on 21.08.25.
//

import XCTest

public typealias UIApplication = XCUIApplication
public typealias ProtectedResource = XCUIProtectedResource
public typealias GestureVelocity = XCUIGestureVelocity
public typealias Timeout = TimeInterval

extension Timeout {

    public static let standard: Self = 1
}

public enum SwipeDirection {
    case up
    case down
}

public enum PreconditionCheck {
    case existence
    case hittable
    case none
}

/// Base class for UI test robots, providing a structured way to interact
/// with the application's UI elements in a maintainable and reusable manner.
///
/// `UIRobot` encapsulates a part of the UI hierarchy and provides
/// convenient methods to locate, check, and interact with elements.
/// Subclasses can override `root` to scope the robot to a specific container.
@MainActor
open class UIRobot {

    /// The application under test.
    public let uiApplication: XCUIApplication

    /// The top-level element specification representing the application.
    ///
    /// This spec acts as the default root for all queries in the robot.
    public let app: UIElementSpec

    /// The root element specification on which this robot operates on.
    ///
    /// Subclasses can override `root` to provide a more specific container
    /// or view to scope element queries. By default, this returns `app`,
    /// which covers the full application.
    ///
    /// - Note: Overriding `root` to a narrower container can improve query
    ///   performance, as `XCUIElementQuery` operations are faster on smaller
    ///   subtrees of the view hierarchy.
    open var root: UIElementSpec {
        return app
    }

    /// Creates a new robot bound to a part of the UI hierarchy.
    ///
    /// - Parameter app: The application instance under test.
    ///   Defaults to a new `UIApplication()`.
    public init(app: UIApplication = UIApplication()) {
        self.uiApplication = app
        self.app = UIElementSpec(identifier: "", type: .application, scope: .app)
    }

    // MARK: Locators

    // MARK: Checks

    /// Waits until the specified UI element specification appears in the view hierarchy.
    ///
    /// - Parameters:
    ///   - elementSpec: The `UIElementSpec` describing the element to wait for.
    ///   - timeout: The maximum duration to wait before giving up. Defaults to `.standard`.
    /// - Throws:
    ///   - `InteractionError.notFoundInViewHierarchy` if the resolved element does not
    ///     appear within the specified timeout.
    ///
    /// - Note:
    ///   Use this method to guard interactions (e.g., taps, typing) against elements
    ///   that may take time to appear. Resolving elements lazily via `UIElementSpec`
    ///   ensures stable failure reporting and avoids querying the view hierarchy
    ///   until absolutely necessary, reducing test flakiness.
    public func waitUntilExists(_ elementSpec: UIElementSpec, timeout: Timeout = .standard) throws {
        let resolved = resolve(elementSpec)

        guard resolved.exists(after: timeout) else {
            throw Error.notFoundInViewHierarchy(elementSpec, timeout)
        }
    }

    /// Waits until the specified UI element disappears from the view hierarchy.
    ///
    /// - Parameters:
    ///   - elementSpec: The `UIElementSpec` describing the element to wait for.
    ///   - timeout: The maximum time to wait before giving up. Defaults to `.standard`.
    /// - Throws:
    ///   - `InteractionError.stillPresentInViewHierarchy` if the element is still present
    ///     after the given timeout.
    public func waitUntilNotExisting(_ elementSpec: UIElementSpec, timeout: Timeout = .standard) throws {
        let resolved = resolve(elementSpec)

        guard resolved.notExists(after: timeout) else {
            throw Error.stillPresentInViewHierarchy(elementSpec, timeout)
        }
    }

    /// Waits until the specified UI element becomes hittable (visible and intractable).
    ///
    /// - Parameters:
    ///   - elementSpec: The specification of the UI element to resolve and observe.
    ///   - timeout: The maximum time to wait before giving up. Defaults to `.standard`.
    ///
    /// - Throws:
    ///   - `InteractionError.notTappable` if the element does not become hittable within the given timeout.
    ///
    public func waitUntilHittable(_ elementSpec: UIElementSpec, timeout: Timeout = .standard) throws {
        let resolved = resolve(elementSpec)

        guard resolved.isHittable(after: timeout) else {
            throw Error.notHittable(elementSpec, timeout)
        }
    }

    // MARK: Interactions

    /// Taps the specified UI element specification, waiting for it to appear if necessary.
    ///
    /// - Parameters:
    ///   - elementSpec: The `UIElementSpec` describing the element to tap.
    ///   - precondition: A condition to be evaluated before executing the tap. Defaults to `.hittable`
    ///   - timeout: The maximum time to wait for the element to appear before failing. Defaults to `.standard`.
    /// - Throws:
    ///   - `InteractionError.notFoundInViewHierarchy` if the resolved element does not appear within the timeout.
    public func tap(_ elementSpec: UIElementSpec,
                    checking precondition: PreconditionCheck = .hittable,
                    timeout: Timeout = .standard) throws {

        try evaluate(precondition: precondition,
                     for: elementSpec,
                     timeout: timeout)

        // TODO: reduce the need of resolving the spec twice with internal variants
        let resolved = resolve(elementSpec)
        resolved.tap()
    }

    /// Enters the provided text into the given UI element specification.
    ///
    /// This method first ensures the target element is ready for text input by tapping it
    /// (waiting until it becomes hittable), and then types the supplied text into it.
    /// Use this for text fields, search bars, secure fields, or any element that accepts keyboard input.
    ///
    /// - Parameters:
    ///   - text: The string to type into the target element.
    ///   - elementSpec: A `UIElementSpec` describing the element that should receive the text.
    ///
    /// - Important:
    ///   This method taps the element before typing. If tapping changes focus or triggers navigation,
    ///   ensure the element remains the intended target for text entry.
    ///
    /// - SeeAlso:
    ///   - ``tap(_:checking:timeout:)``
    ///   - ``waitUntilHittable(_:timeout:)``
    ///   - ``UIElementSpec``
    public func enterText(_ text: String, into elementSpec: UIElementSpec) throws {
        try tap(elementSpec)

        let resolved = resolve(elementSpec)
        resolved.typeText(text)
    }

    /// Performs repeated upward swipes on the screen until a given condition on a target element is satisfied or the timeout expires.
    ///
    /// This is useful for scrolling a list, table, or any scrollable view until the element is visible or otherwise meets a desired state.
    ///
    /// - Parameters:
    ///   - direction: The direction to swipe
    ///   - elementSpec: The `UIElementSpec` to monitor while swiping.
    ///   - condition: A closure that evaluates whether the resolved element has reached the desired state (e.g., `.isHittable`).
    ///   - timeout: Maximum duration to keep swiping before throwing an error. Defaults to `5`s.
    ///
    /// - Throws: `InteractionError.conditionTimeout` if the element never satisfies the condition within the given timeout.
    public func swipe(_ direction: SwipeDirection,
        until elementSpec: UIElementSpec,
        satisfies condition: @escaping (XCUIElement) -> Bool,
        withVelocity velocity: GestureVelocity = .default,
        timeout: Timeout = 5
    ) throws {
        let resolvedRoot = resolve(root)
        let resolvedElement = resolve(elementSpec)
        let deadline = Deadline(timeout: timeout)

        while !condition(resolvedElement) {
            if deadline.isElapsed() {
                throw Error.conditionTimeout(elementSpec, timeout)
            }

            switch direction {
                case .up:
                    resolvedRoot.swipeUp(velocity: velocity)
                case .down:
                    resolvedRoot.swipeDown(velocity: velocity)
            }
        }
    }

    // MARK: XCUIElement resolution

    /// Converts a `UIElementSpec` into an `XCUIElement` for interaction.
    ///
    /// - Parameter elementSpec: The specification of the element to resolve.
    /// - Returns: The corresponding `XCUIElement`.
    public func resolve(_ elementSpec: UIElementSpec) -> XCUIElement {
        if elementSpec.type == .application {
            return uiApplication
        }

        switch elementSpec.scope {
            case .app:
                return uiApplication.descendants(matching: elementSpec.type)[elementSpec.identifier]
            case let .descendantOf(parentSpec):
                return resolve(parentSpec).descendants(matching: elementSpec.type)[elementSpec.identifier]
        }
    }

    // MARK: Issue reporting

    public func report(error: Error, sourceLocation: SourceLocation) {
        Issue.report(error: error, sourceLocation: sourceLocation)
    }

    // MARK: Private

    private func evaluate(precondition: PreconditionCheck,
                          for elementSpec: UIElementSpec,
                          timeout: Timeout) throws {
        switch precondition {
            case .existence:
                try waitUntilExists(elementSpec, timeout: timeout)
            case .hittable:
                try waitUntilHittable(elementSpec, timeout: timeout)
            case .none:
                break
        }
    }
}
