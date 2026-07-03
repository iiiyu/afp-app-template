import DesignSystem
import SwiftUI

/// Paywall skeleton. Kept out of the demo flow until a spec defines products.
public struct PaywallView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: DS.Spacing.md) {
            Text("Unlock everything")
                .font(DS.Typography.screenTitle)
            Text("Template paywall placeholder. No products configured.")
                .font(DS.Typography.caption)
                .foregroundStyle(DS.Palette.textSecondary)
        }
        .padding(DS.Spacing.lg)
    }
}
