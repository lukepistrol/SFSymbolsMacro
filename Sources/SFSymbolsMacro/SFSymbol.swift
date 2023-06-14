//
//  SFSymbol.swift
//  SFSymbolsMacro/SFSymbolsMacro
//
//  Created by Lukas Pistrol on 14.06.23.
//
@attached(member, names: arbitrary)
public macro SFSymbol() = #externalMacro(module: "SFSymbolsMacroImpl", type: "SFSymbolMacro")
