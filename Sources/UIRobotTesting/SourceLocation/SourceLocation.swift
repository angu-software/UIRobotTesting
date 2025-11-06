//
//  SourceLocation.swift
//  UIRobotTesting
//
//  Created by Andreas Günther on 04.09.25.
//

public struct SourceLocation {

    public static func at(filePath: StaticString, line: UInt) -> Self {
        return Self(filePath: filePath, line: line)
    }

    public let filePath: StaticString
    public let line: UInt
}
