//
//  SFSymbolsMacroPlugin.swift
//  SFSymbolsMacro/SFSymbolsMacroImpl
//
//  Created by Lukas Pistrol on 14.06.23.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SFSymbolsMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SFSymbolMacro.self
    ]
}
