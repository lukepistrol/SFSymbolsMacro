// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SFSymbolsMacro",
    platforms: [.macOS(.v11), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "SFSymbolsMacro",
            targets: ["SFSymbolsMacro"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.1.1"),
    ],
    targets: [
        .macro(
            name: "SFSymbolsMacroImpl",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        .target(name: "SFSymbolsMacro", dependencies: ["SFSymbolsMacroImpl"]),

        .testTarget(
            name: "SFSymbolsMacroTests",
            dependencies: [
                "SFSymbolsMacroImpl",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
