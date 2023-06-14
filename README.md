# SFSymbolsMacro

This Swift Macro provides an easy way to make the use of SF Symbols in Swift more or less *"type-safe"*.

## Usage

Simply create an `enum` which will hold all the SF Symbols for your project:

```swift
enum Symbols: String {
    case circle
    case circleFill = "circle.fill"
    case shareIcon = "square.and.arrow.up"
}
```

Then simply import `SFSymbolsMacro` and add the `@SFSymbol` macro annotation to the enum:

```swift
import SFSymbolsMacro

@SFSymbol
enum Symbols: String { ... }
```

The macro will then validate each `case` and add the expanded macro will look something like this:

```swift
enum Symbols: String {
    case circle
    case circleFill = "circle.fill"
    case shareIcon = "square.and.arrow.up"

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
```

## Contribution

If you have any ideas on how to take this further I'm happy to discuss things in an issue.
