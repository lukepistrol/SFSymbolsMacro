//
//  SFSymbolsDiagnostic.swift
//  SFSymbolsMacro/SFSymbolsMacroImpl
//
//  Created by Lukas Pistrol on 14.06.23.
//

import SwiftDiagnostics

enum SFSymbolDiagnostic: DiagnosticMessage {
    case noValidSFSymbol(symbol: String)

    var severity: DiagnosticSeverity { return .error }

    var message: String {
        switch self {
        case .noValidSFSymbol(let symbol):
            "\"\(symbol)\" is not a valid SF Symbol."
        }
    }

    var diagnosticID: MessageID {
        MessageID(domain: "SFSymbolMacro", id: self.message)
    }
}
