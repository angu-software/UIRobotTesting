# Building a Robot

**ARTICLE DRAFT**

## Anatomy of a Robot

```swift

import XCTest

import UIRobotTesting

final class MyRobot: UIRobot { // Robot definition

    // Define a custom root element to scope the robots context
    override var root: UIElementSpec {
        return super.root.descendant("screen_box_cat")
    }

    // Use Case method, Describes an user facing use case for the robots context
    @discardableResult // <- Design decision, if the result is meant to be handled
    func selectTapBox(sourceLocation: SourceLocation = #source_location) -> Self {
        withFailureReport(at: sourceLocation) { // <- Design decision, should you robot should raise a XCTFailureIssue or throw?
            let boxButton = root.descendant("button_cat_box") // Obtaining an ui element for interaction

            try tap(boxButton) // <- Interaction
        }

        return self // <- design decision if you return anything here, or the next logically following robot or simply self. See `Building a Robot DSL`
    }
}

```

## Special Robots

* ``SpringboardRobot``
