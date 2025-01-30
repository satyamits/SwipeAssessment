// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Product {
    /// Detailed View
    internal static let detailsTitle = L10n.tr("Localizable", "product.detailsTitle", fallback: "Detailed View")
    /// Products
    internal static let listingTitle = L10n.tr("Localizable", "product.listingTitle", fallback: "Products")
  }
  internal enum Ratings {
    /// DONE
    internal static let done = L10n.tr("Localizable", "ratings.done", fallback: "DONE")
    /// Tell us more (optional)
    internal static let tellUsMore = L10n.tr("Localizable", "ratings.tellUsMore", fallback: "Tell us more (optional)")
    /// Congratulations 🎉
    /// You’ve identified your first plant🪴.
    /// Like the results?
    internal static let title = L10n.tr("Localizable", "ratings.title", fallback: "Congratulations 🎉\nYou’ve identified your first plant🪴.\nLike the results?")
    /// Write your feedback
    internal static let writeYourFeedback = L10n.tr("Localizable", "ratings.writeYourFeedback", fallback: "Write your feedback")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
