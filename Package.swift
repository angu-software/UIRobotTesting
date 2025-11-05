// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "UIRobotTesting",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "UIRobotTesting",
            targets: ["UIRobotTesting"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0-latest"),
    ],
    targets: [
        .target(
            name: "UIRobotTesting",
            dependencies: ["UIRobotMacros"]),
        .testTarget(
            name: "UIRobotTestingTests",
            dependencies: ["UIRobotTesting"]
        ),
        .macro(name: "UIRobotMacros",
               dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
               ]),
        .testTarget(
            name: "UIRobotMacroTests",
            dependencies: [
                "UIRobotMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
