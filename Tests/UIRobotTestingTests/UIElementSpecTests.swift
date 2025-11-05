//
//  UIElementSpecTests.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 18.09.25.
//

import Testing

@testable import UIRobotTesting

struct UIElementSpecTests {

    @Test
    func testHierarchyPath_whenTypeIsNotSpecfied_itOnlyContainsTheElementIdentifier() async throws {
        let uIElementSpec = UIElementSpec(identifier: "root-element",
                                          scope: .app)
            .descendant("descendant-element")

        #expect(uIElementSpec.hierarchyPath == "app.root-element.descendant-element")
    }

    @Test
    func testHierarchyPath_whenTypeIsSpecified_itContainsTheElementsType() async throws {
        let uIElementSpec = UIElementSpec(identifier: "root-element",
                                          type: .activityIndicator,
                                          scope: .app)
            .descendant("descendant-element",
                        ofType: .checkBox)

        #expect(uIElementSpec.hierarchyPath == "app.ActivityIndicator[root-element].CheckBox[descendant-element]")
    }

    @Test
    func testHierarchyPath_whenTypeIsApp_itReturnsApp() async throws {
        let uIElementSpec = UIElementSpec(identifier: "",
                                          type: .application,
                                          scope: .app)

        #expect(uIElementSpec.hierarchyPath == "app")
    }

    @Test
    func testHierarchyPath_whenTypeIsApp_whenItHasAnIdentifier_itReturnsAppWithIdentifier() async throws {
        let uIElementSpec = UIElementSpec(identifier: "my.cool.app",
                                          type: .application,
                                          scope: .app)

        #expect(uIElementSpec.hierarchyPath == "app(my.cool.app)")
    }
}
