//
//  SFSymbol.swift
//  SFSymbolsMacro/SFSymbolsMacro
//
//  Created by Lukas Pistrol on 14.06.23.
//

/**
 A Swift macro for *"type-safe"* SF Symbols.

 ## Initialization
 ```swift
 @SFSymbol
 enum Symbols: String {
   case globe
   case circleFill = "circle.fill"
 }
 ```

 ## Usage
 ```swift
 var body: some View {
   Symbols.circleFill.image // ~= Image(systemName: "circle.fill")
   Label("Globe", systemImage: Symbols.globe.name) // ~= Label("Globe", systemImage: "globe")
   // the above can also be written as
   Label("Globe", systemImage: Symbols.globe())
 }
 ```
 */
@attached(member, names: arbitrary)
public macro SFSymbol() = #externalMacro(module: "SFSymbolsMacroImpl", type: "SFSymbolMacro")
