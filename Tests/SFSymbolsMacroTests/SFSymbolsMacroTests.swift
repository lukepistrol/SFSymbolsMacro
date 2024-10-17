import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SFSymbolsMacroImpl

let testMacros: [String: Macro.Type] = [
    "SFSymbol": SFSymbolMacro.self,
]

final class SFSymbolsMacroTests: XCTestCase {

    func testSFSymbolMacro() {
        assertMacroExpansion(
            """
            @SFSymbol
            enum Symbols: String {
                case globe
                case circleFill = "circle.fill"
            }
            """,
            expandedSource:
            """

            enum Symbols: String {
                case globe
                case circleFill = "circle.fill"

                var image: Image {
                    Image(systemName: self.rawValue)
                }

                var name: String {
                    self.rawValue
                }

                #if canImport(UIKit)
                func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                    UIImage(systemName: self.rawValue, withConfiguration: configuration)!
                }
                #else
                func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                    return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
                }
                #endif

                func callAsFunction() -> String {
                    return self.rawValue
                }
            }
            """,
            macros: testMacros
        )
    }

    func testPublicSFSymbolMacro() {
        assertMacroExpansion(
            """
            @SFSymbol
            public enum Symbols: String {
                case globe
                case circleFill = "circle.fill"
            }
            """,
            expandedSource:
            """

            public enum Symbols: String {
                case globe
                case circleFill = "circle.fill"

                public var image: Image {
                    Image(systemName: self.rawValue)
                }

                public var name: String {
                    self.rawValue
                }

                #if canImport(UIKit)
                public func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                    UIImage(systemName: self.rawValue, withConfiguration: configuration)!
                }
                #else
                public func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                    return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
                }
                #endif

                public func callAsFunction() -> String {
                    return self.rawValue
                }
            }
            """,
            macros: testMacros
        )
    }

    func testInternalSFSymbolMacro() {
        assertMacroExpansion(
            """
            @SFSymbol
            internal enum Symbols: String {
                case globe
                case circleFill = "circle.fill"
            }
            """,
            expandedSource:
            """

            internal enum Symbols: String {
                case globe
                case circleFill = "circle.fill"

                internal var image: Image {
                    Image(systemName: self.rawValue)
                }

                internal var name: String {
                    self.rawValue
                }

                #if canImport(UIKit)
                internal func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                    UIImage(systemName: self.rawValue, withConfiguration: configuration)!
                }
                #else
                internal func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                    return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
                }
                #endif

                internal func callAsFunction() -> String {
                    return self.rawValue
                }
            }
            """,
            macros: testMacros
        )
    }

    func testFilePrivateSFSymbolMacro() {
        assertMacroExpansion(
            """
            @SFSymbol
            fileprivate enum Symbols: String {
                case globe
                case circleFill = "circle.fill"
            }
            """,
            expandedSource:
            """

            fileprivate enum Symbols: String {
                case globe
                case circleFill = "circle.fill"

                fileprivate var image: Image {
                    Image(systemName: self.rawValue)
                }

                fileprivate var name: String {
                    self.rawValue
                }

                #if canImport(UIKit)
                fileprivate func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                    UIImage(systemName: self.rawValue, withConfiguration: configuration)!
                }
                #else
                fileprivate func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                    return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
                }
                #endif

                fileprivate func callAsFunction() -> String {
                    return self.rawValue
                }
            }
            """,
            macros: testMacros
        )
    }

    func testPrivateSFSymbolMacro() {
        assertMacroExpansion(
            """
            @SFSymbol
            private enum Symbols: String {
                case globe
                case circleFill = "circle.fill"
            }
            """,
            expandedSource:
            """

            private enum Symbols: String {
                case globe
                case circleFill = "circle.fill"

                private var image: Image {
                    Image(systemName: self.rawValue)
                }

                private var name: String {
                    self.rawValue
                }

                #if canImport(UIKit)
                private func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                    UIImage(systemName: self.rawValue, withConfiguration: configuration)!
                }
                #else
                private func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                    return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
                }
                #endif

                private func callAsFunction() -> String {
                    return self.rawValue
                }
            }
            """,
            macros: testMacros
        )
    }

    func testInvalidSFSymbolError() {
        assertMacroExpansion(
            """
            @SFSymbol
            enum Symbols: String {
                case circleFill
            }
            """,
            expandedSource:
            """

            enum Symbols: String {
                case circleFill
            }
            """,
            diagnostics: [
                .init(message: "\"circleFill\" is not a valid SF Symbol.", line: 3, column: 5)
            ],
            macros: testMacros
        )
    }

    func testInvalidSFSymbolErrorExplicit() {
        assertMacroExpansion(
            """
            @SFSymbol
            enum Symbols: String {
                case xyz = "xyz"
            }
            """,
            expandedSource:
            """

            enum Symbols: String {
                case xyz = "xyz"
            }
            """,
            diagnostics: [
                .init(message: "\"xyz\" is not a valid SF Symbol.", line: 3, column: 5)
            ],
            macros: testMacros
        )
    }

    func testInvalidEnum() {
        assertMacroExpansion(
            """
            @SFSymbol
            enum Symbols {
                case globe
            }
            """,
            expandedSource:
            """

            enum Symbols {
                case globe
            }
            """,
            diagnostics: [
                .init(message: "Enum \"Symbols\" must declare a raw value type of String.", line: 2, column: 6)
            ],
            macros: testMacros
        )
    }

    func testInvalidType() {
        assertMacroExpansion(
            """
            @SFSymbol
            struct Symbols {
                let xyz = "xyz"
            }
            """,
            expandedSource:
            """

            struct Symbols {
                let xyz = "xyz"
            }
            """,
            diagnostics: [
                .init(message: "Macro \"@SFSymbol\" can only be applied to enums.", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testInvalidModifier() {
        assertMacroExpansion(
            """
            @SFSymbol
            struct Symbols {
                let xyz = "xyz"
            }
            """,
            expandedSource:
            """

            struct Symbols {
                let xyz = "xyz"
            }
            """,
            diagnostics: [
                .init(message: "Macro \"@SFSymbol\" can only be applied to enums.", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
