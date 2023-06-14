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
}
