//
//  Fonts.swift
//  SecureTradingUI
//

import UIKit

enum Fonts {
    // MARK: Base

//    /// Enum describing font weight.
//    enum FontWeight: String {
//        case regularDisplay = "Display-Regular"
//        case regularText = "Text-Regular"
//        case light = "Text-Light"
//        case medium = "Display-Medium"
//        case semibold = "Display-Semibold"
//        case bold = "Display-Bold"
//    }

    /// Returns responsive font with given weight and sizes.
    ///
    /// - Parameters:
    ///   - weight: Font weight.
    ///   - sizes: Font sizes.
    /// - Returns: Responsive font.
    static func responsive(_ weight: UIFont.Weight, ofSizes sizes: [SizeClass: CGFloat]) -> UIFont {
        return responsive(ofSizes: sizes, init: font(weight))
    }

    /// Curried function which takes font weight and size and then returns ready to use font.
    ///
    /// - Parameter weight: Font weight.
    /// - Returns: Closure which takes font size as an argument and returns font.
    private static func font(_ weight: UIFont.Weight) -> (_ size: CGFloat) -> UIFont {
        return { size in
            font(weight, ofSize: size)
        }
    }

    /// Function which returns font of given weight and size.
    ///
    /// - Parameters:
    ///   - weight: Font weight.
    ///   - size: Font size.
    /// - Returns: Font.
    static func font(_ weight: UIFont.Weight, ofSize size: CGFloat) -> UIFont {
        // return UIFont(name: "SFPro\(weight.rawValue)", size: size)!
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    // MARK: Responsive

    /// Represents a size class for responsive font measurement.
    enum SizeClass {
        /// A size class for screens narrower than 320pt.
        /// In other words, for iPhone SE.
        case small

        /// A size class for screens wider than 320pt but narrower than 414pt.
        /// In other words, for iPhone 8 and XS.
        case medium

        /// A size class for screens wider than 414pt.
        /// In other words, for iPhone 8 Plus, XS Max and XR.
        case large
    }

    /// A responsive font of given sizes to choose from.
    ///
    /// - Parameters:
    ///     - sizes: Sizes to choose from. Must not be empty.
    ///
    /// - Returns: A font.
    private static func responsive(ofSizes sizes: [SizeClass: CGFloat], init: (CGFloat) -> UIFont) -> UIFont {
        guard !sizes.isEmpty else {
            fatalError("You must provide a font size for at least one size class.")
        }

        let sizeClass: SizeClass = {
            switch UIScreen.main.bounds.width {
            case ...320: return .small
            case 414...: return .large
            default: return .medium
            }
        }()

        let size: CGFloat = {
            switch sizeClass {
            case .small: return (sizes[.small] ?? sizes[.medium] ?? sizes[.large])!
            case .medium: return (sizes[.medium] ?? sizes[.small] ?? sizes[.large])!
            case .large: return (sizes[.large] ?? sizes[.medium] ?? sizes[.small])!
            }
        }()

        return `init`(size)
    }

    /// A responsive font size of given sizes to choose from.
    /// - Parameter sizes: Sizes to choose from. Must not be empty.
    static func getFontSize(ofSizes sizes: [SizeClass: CGFloat]) -> CGFloat {
        guard !sizes.isEmpty else {
            fatalError("You must provide a font size for at least one size class.")
        }

        let sizeClass: SizeClass = {
            switch UIScreen.main.bounds.width {
            case ...320: return .small
            case 414...: return .large
            default: return .medium
            }
        }()

        let size: CGFloat = {
            switch sizeClass {
            case .small: return (sizes[.small] ?? sizes[.medium] ?? sizes[.large])!
            case .medium: return (sizes[.medium] ?? sizes[.small] ?? sizes[.large])!
            case .large: return (sizes[.large] ?? sizes[.medium] ?? sizes[.small])!
            }
        }()

        return size
    }
}
