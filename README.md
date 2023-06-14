<p>
  <img src="https://img.shields.io/badge/Swift-5.9-f05318.svg" />
  <img src="https://img.shields.io/badge/iOS->= 13.0-blue.svg" />
  <img src="https://img.shields.io/badge/macOS->= 11.0-blue.svg" />
  <img src="https://img.shields.io/badge/watchOS->= 6.0-blue.svg" />
  <img src="https://img.shields.io/badge/tvOS->= 13.0-blue.svg" />
  <img alt="GitHub" src="https://img.shields.io/github/license/lukepistrol/SFSymbolsMacro">
  <a href="https://twitter.com/lukeeep_">
    <img src="https://img.shields.io/badge/Twitter-@lukeeep_-1e9bf0.svg?style=flat" alt="Twitter: @lukeeep_" />
  </a>
</p>

# SFSymbolsMacro

This Swift Macro provides an easy way to make the use of SF Symbols in Swift more or less *"type-safe"*.

## Installation

### Xcode

1. Click File > Add Package Dependencies
2. Paste the following link into the search field on the upper-right:
   ```
   https://github.com/lukepistrol/SFSymbolsMacro.git
   ```

### Swift Package Manager

In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/lukepistrol/SFSymbolsMacro.git", from: "0.1.0")
]
```

And then add the dependency to your targets.

## Usage

Simply create an `enum` which will hold all the SF Symbols for your project:

```swift
enum Symbols: String {
    case circle
    case circleFill = "circle.fill"
    case shareIcon = "square.and.arrow.up"
    case globe
}
```

Then simply import `SFSymbolsMacro` and add the `@SFSymbol` macro annotation to the enum:

```swift
import SFSymbolsMacro
import SwiftUI

@SFSymbol
enum Symbols: String { ... }
```

The macro will then validate each `case` and the expanded macro will look something like this:

```swift
enum Symbols: String {
    case circle
    case circleFill = "circle.fill"
    case shareIcon = "square.and.arrow.up"
    case globe

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
```

In your code you can then call a symbol:

```swift
var body: some View {
    VStack {
        Symbols.circleFill.image
        Label("Globe", systemImage: Symbols.globe.name)
        // the above can also be written as
        Label("Globe", systemImage: Symbols.globe())
    }
}
```

In case the provided raw value is not a valid SF Symbol, Xcode will show a compile error at the `enum-case` in question:

![explicit raw value](https://github.com/lukepistrol/SFSymbolsMacro/assets/9460130/36713049-6b14-4fc4-8a07-df86837e4704)

![inferred raw value](https://github.com/lukepistrol/SFSymbolsMacro/assets/9460130/9db30861-4b98-4e31-9c41-0b5e0a553293)


## Contribution

If you have any ideas on how to take this further I'm happy to discuss things in an issue.

-----

<a href="https://www.buymeacoffee.com/lukeeep" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
