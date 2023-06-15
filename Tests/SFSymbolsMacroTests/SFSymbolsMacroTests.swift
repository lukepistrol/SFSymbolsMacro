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
                .init(message: "Enum \"Symbols\" needs conformance to String protocol.", line: 2, column: 6)
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
}
