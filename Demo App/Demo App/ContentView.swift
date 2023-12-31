//
//  ContentView.swift
//  Demo App
//
//  Created by Lukas Pistrol on 20.06.23.
//

import SwiftUI
import SFSymbolsMacro

@SFSymbol
enum Symbols: String, CaseIterable {
    case globe
    case folder
    case folderFill = "folder.fill"
    case folderBadgeMinus = "folder.badge.minus"
    case folderBadgeQuestionmark = "folder.badge.questionmark"
    case square
    case squareSlash = "square.slash"
    case squareLefthalfFilled = "square.lefthalf.filled"
    case squareInsetFilled = "square.inset.filled"
    case squareSplitDiagonalFill = "square.split.diagonal.fill"
}

struct ContentView: View {
    var body: some View {
        VStack {
            Label("Hello, World!", systemImage: Symbols.globe())
            Spacer()
            LazyVGrid(columns: columns) {
                ForEach(Symbols.allCases) { symbol in
                    symbol.image
                        .imageScale(.medium)
                        .font(.largeTitle)
                }
            }
        }
        .padding()
    }

    private var columns: [GridItem] {
        .init(repeating: GridItem(.fixed(50)), count: 5)
    }
}

extension Symbols: Identifiable {
    var id: String { self.rawValue }
}

#Preview {
    ContentView()
}
