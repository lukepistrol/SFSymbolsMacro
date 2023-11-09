//
//  SFSymbolsMacro.swift
//  SFSymbolsMacro/SFSymbolsMacroImpl
//
//  Created by Lukas Pistrol on 14.06.23.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftUI

public struct SFSymbolMacro: MemberMacro {

    private typealias SymbolPair = (id: String, node: Syntax)

    public static func expansion<
        Declaration: DeclGroupSyntax, Context: MacroExpansionContext
    >(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        try validate(declaration)
        let accessLevel = try getAccessLevel(declaration)

        return [
            """
            \(raw: accessLevel)var image: Image {
                Image(systemName: self.rawValue)
            }
            """,
            """
            \(raw: accessLevel)var name: String {
                self.rawValue
            }
            """,
            """
            #if canImport(UIKit)
            \(raw: accessLevel)func uiImage(configuration: UIImage.Configuration? = nil) -> UIImage {
                UIImage(systemName: self.rawValue, withConfiguration: configuration)!
            }
            #else
            \(raw: accessLevel)func nsImage(accessibilityDescription: String? = nil) -> NSImage {
                return NSImage(systemSymbolName: self.rawValue, accessibilityDescription: accessibilityDescription)!
            }
            #endif
            """,
            """
            \(raw: accessLevel)func callAsFunction() -> String {
                return self.rawValue
            }
            """
        ]
    }

    // MARK: Helper Methods

    private static func validate(_ declaration: DeclGroupSyntax) throws {
        try validateStringProtocolInheritance(declaration)
        let members = declaration.memberBlock.members
        let cases = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let ids = getIdentifiers(from: cases)
        try ids.forEach { id throws in
            try assertUINSImage(for: id)
        }
    }

    private static func validateStringProtocolInheritance(_ declaration: DeclGroupSyntax) throws {
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw DiagnosticsError(diagnostics: [
                .init(node: Syntax(declaration), message: SFSymbolDiagnostic.notAnEnum)
            ])
        }
        let identifier = enumDecl.name
        guard enumDecl.inheritanceClause?.inheritedTypes.contains(where: {
            $0.type.as(IdentifierTypeSyntax.self)?.name.text == "String"
        }) ?? false else {
            throw DiagnosticsError(diagnostics: [
                .init(node: Syntax(identifier), message: SFSymbolDiagnostic.missingStringProtocolConformance(symbol: identifier.text))
            ])
        }
    }

    /// Gets either the rawValue (if available) or the identifier of the enum case.
    private static func getIdentifiers(from cases: [EnumCaseDeclSyntax]) -> [SymbolPair] {
        return cases.flatMap { enumCase in
            let a = enumCase.elements.map {
                let idNode = $0.rawValue?.value.as(StringLiteralExprSyntax.self)?.segments.first {
                    $0.as(StringSegmentSyntax.self) != nil
                }
                let id = idNode?.as(StringSegmentSyntax.self)?.content.text ?? $0.name.text
                let syntax = Syntax(enumCase)
                return (id: id, node: syntax)
            }
            return a
        }
    }

    private static func assertUINSImage(for id: (SymbolPair)) throws {
        #if canImport(UIKit)
        if let _ = UIImage(systemName: id.id) { return }
        #else
        if let _ = NSImage(systemSymbolName: id.id, accessibilityDescription: nil) { return }
        #endif
        throw DiagnosticsError(diagnostics: [
            .init(node: id.node, message: SFSymbolDiagnostic.noValidSFSymbol(symbol: id.0))
        ])
    }

    /// Gets access level
    private static func getAccessLevel(_ declaration: DeclGroupSyntax) throws -> String {
        guard let enumdeclaration = declaration.as(EnumDeclSyntax.self) else {
            throw DiagnosticsError(diagnostics: [
                .init(node: Syntax(declaration), message: SFSymbolDiagnostic.notAnEnum)
            ])
        }
        guard let accessLevel = enumdeclaration.modifiers.first(where: \.isNeededAccessLevelModifier)?.name.trimmed else {
            return ""
        }
        return "\(accessLevel.text) "
    }
}

extension DeclModifierSyntax {
  var isNeededAccessLevelModifier: Bool {
    switch self.name.tokenKind {
    case .keyword(.public): return true
    case .keyword(.internal): return true
    case .keyword(.fileprivate): return true
    case .keyword(.private): return true
    default: return false
    }
  }
}
