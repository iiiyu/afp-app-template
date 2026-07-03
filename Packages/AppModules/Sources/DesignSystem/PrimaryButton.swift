import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DS.Typography.body.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, DS.Spacing.sm + DS.Spacing.xs)
            .background(DS.Palette.accent, in: RoundedRectangle(cornerRadius: DS.Radius.control))
            .foregroundStyle(.white)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    public static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}
