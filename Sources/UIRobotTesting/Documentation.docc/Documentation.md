# ``UIRobotTesting``

A Swift toolkit for writing robust, maintainable UI tests with “robots,” declarative element specs, and consistent failure reporting.

## Overview

UIRobotTesting helps you structure UI tests around screen-focused “robots” and stable element locators. It provides:
- A base robot type (``UIRobot``) that scopes interactions to parts of the UI hierarchy.
- Declarative element specifications (``UIElementSpec`` and ``UIElementScope``) for late-bound, stable queries.
- Consistent waiting and interaction helpers with clear, human-readable error messages (``UIRobot/Error``).
- Convenience extensions for existence and hittability checks on ``XCUIElement``.
- A lightweight issue reporting utility (``Issue``) and a macro-powered source location API (``SourceLocation`` and ``#source_location``) so failures point to the calling test line.
- Small utilities like ``withFailureReport(at:action:)`` and ``Deadline`` to implement time-bound polling.

Supported platforms: iOS and other Apple platforms that support XCTest UI testing.

## Why not use raw XCTest UI testing?

Directly using XCTest’s UI APIs (XCUIApplication, XCUIElement queries, waits) works, but it often leads to:
- Scattered, brittle selectors
  - Element queries and identifiers are duplicated across tests, making refactors risky and increasing flakiness. With ``UIElementSpec`` you centralize and compose locators, improving reuse and readability via ``UIElementSpec/hierarchyPath`` in errors.
- Ad-hoc waiting logic
  - Tests commonly mix waitForExistence, sleeps, and custom predicates inconsistently. ``UIRobot`` provides consistent preconditions (``PreconditionCheck``) and timeouts (``Timeout`` and ``Timeout/standard``) behind high-level APIs like ``UIRobot/tap(_:checking:timeout:)`` and ``UIRobot/waitUntilHittable(_:timeout:)``.
- Poor failure diagnostics
  - Raw XCTFail calls or thrown errors can point to helper internals instead of the test line. Using ``withFailureReport(at:action:)`` with ``#source_location`` ensures ``Issue`` reports failures at the calling test site, with clear messages from ``UIRobot/Error`` (for example, not found, not hittable, still present, or condition timeouts).
- Boilerplate and duplication
  - Each test reimplements navigation and interactions. Robots encapsulate flows and screen knowledge, so tests read like scenarios while reusing the same, battle-tested steps.
- Unstructured scrolling and conditions
  - Repeated swipe/wait loops are error-prone. ``UIRobot/swipe(_:until:satisfies:withVelocity:timeout:)`` gives a clear, time-bounded pattern for reaching conditions.
- Inconsistent semantics across teams
  - Centralized helpers like ``XCUIElement/exists(after:)``, ``XCUIElement/isHittable(after:)``, and ``XCUIElement/notExists(after:)`` standardize behavior, reducing surprises.

In short, UIRobotTesting turns low-level UI operations into reusable building blocks with consistent waits, diagnostics, and error messages—leading to more stable and maintainable test suites.

## Quick Start

1) Create a robot for your screen by subclassing ``UIRobot`` and describing elements with ``UIElementSpec``:
```swift
import UIRobotTesting
import XCTest

final class LoginRobot: UIRobot {
    private var usernameField: UIElementSpec {
        root.descendant("username", ofType: .textField)
    }
    private var passwordField: UIElementSpec {
        root.descendant("password", ofType: .secureTextField)
    }
    private var loginButton: UIElementSpec {
        root.descendant("login_button", ofType: .button)
    }

    func login(username: String, password: String, at location: SourceLocation = #source_location) {
        withFailureReport(at: location) {
            try enterText(username, into: usernameField)
            try enterText(password, into: passwordField)
            try tap(loginButton)
        }
    }
}
