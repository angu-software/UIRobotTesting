//
//  SpringboardRobot.swift
//  Pandocs
//
//  Created by Andreas Günther on 21.08.25.
//

import XCTest

/// A `UIRobot` specialized for interacting with the iOS SpringBoard.
///
/// This robot provides access to the system-level UI outside the app’s own process,
/// such as handling permission alerts, notifications, or system dialogs.
///
/// - Important: The SpringBoard belongs to iOS itself (`com.apple.springboard`),
///   so interactions with it may differ from those within the app and can be more
///   prone to timing issues.
///
/// ### Usual Purpose
/// `SpringboardRobot` is typically used for:
/// - Dismissing system permission prompts (e.g., Camera, Health, Notifications).
/// - Handling the App Tracking Transparency (ATT) alert.
/// - Interacting with the home screen (e.g., verifying app installation, launching apps).
/// - Responding to unexpected system alerts that can block automated test flows.
/// - Interact with the keyboard
///
/// - Note: This robot initializes its `app` with the SpringBoard bundle identifier,
///   and has no parent element.
open class SpringboardRobot: UIRobot {

    required public init() {
        super.init(app: UIApplication(bundleIdentifier: "com.apple.springboard"))
    }
}
