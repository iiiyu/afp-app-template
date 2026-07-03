import DesignSystem
import SwiftUI

/// Onboarding flow skeleton. scaffold-from-spec replaces the pages with content
/// from the spec package; the completion contract stays the same.
public struct OnboardingView: View {
    private let onFinished: () -> Void

    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }

    public var body: some View {
        VStack(spacing: DS.Spacing.lg) {
            Spacer()
            Text("Welcome")
                .font(DS.Typography.screenTitle)
            Text("Template onboarding placeholder.")
                .font(DS.Typography.body)
                .foregroundStyle(DS.Palette.textSecondary)
            Spacer()
            Button("Continue", action: onFinished)
                .buttonStyle(.primary)
        }
        .padding(DS.Spacing.lg)
        .background(DS.Palette.background)
    }
}
