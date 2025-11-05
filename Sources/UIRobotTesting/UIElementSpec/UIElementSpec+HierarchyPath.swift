//
//  UIElementSpec+HierarchyPath.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 18.09.25.
//

import Foundation

extension UIElementSpec {

    public var hierarchyPath: String {
        if type == .application {

            if identifier.isEmpty {
                return "app"
            } else {
                return "app(\(identifier))"
            }
        }

        var hierarchy: [String] = []
        switch scope {
            case .app:
                hierarchy.append("app")
            case let .descendantOf(parentElement):
                hierarchy.append(parentElement.hierarchyPath)
        }

        if type.name.isEmpty {
            hierarchy.append(identifier)
        } else {
            hierarchy.append("\(type.name)[\(identifier)]")
        }

        return hierarchy
            .compactMap({ $0.isEmpty ? nil : $0 })
            .joined(separator: ".")
    }
}
