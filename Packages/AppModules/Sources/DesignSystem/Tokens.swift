import SwiftUI

/// Design tokens. scaffold-from-spec rewrites the values in this file from the
/// spec package's `03-ui-contract.md`; feature code references tokens, never raw values.
public enum DS {
    public enum Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
    }

    public enum Radius {
        public static let card: CGFloat = 12
        public static let control: CGFloat = 10
    }

    public enum Palette {
        public static let accent = Color.accentColor
        public static let background = Color(.systemGroupedBackground)
        public static let surface = Color(.secondarySystemGroupedBackground)
        public static let textPrimary = Color.primary
        public static let textSecondary = Color.secondary
    }

    public enum Typography {
        public static let screenTitle = Font.title2.weight(.semibold)
        public static let body = Font.body
        public static let caption = Font.caption
    }
}
