import DesignSystem
import SwiftUI

public struct RootView: View {
    @State private var model = ChecklistModel(items: [
        ChecklistItem(title: "Clone the template"),
        ChecklistItem(title: "Run Scripts/verify.sh"),
        ChecklistItem(title: "Ship to TestFlight"),
    ])
    @State private var draft = ""

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(model.items) { item in
                        Button {
                            model.toggle(id: item.id)
                        } label: {
                            HStack(spacing: DS.Spacing.sm) {
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(DS.Palette.accent)
                                Text(item.title)
                                    .font(DS.Typography.body)
                                    .strikethrough(item.isDone)
                                    .foregroundStyle(
                                        item.isDone ? DS.Palette.textSecondary : DS.Palette.textPrimary
                                    )
                            }
                        }
                    }
                } footer: {
                    Text("\(model.remainingCount) remaining")
                        .font(DS.Typography.caption)
                        .accessibilityIdentifier("checklist.remaining")
                }

                Section {
                    HStack(spacing: DS.Spacing.sm) {
                        TextField("New item", text: $draft)
                            .accessibilityIdentifier("checklist.input")
                        Button("Add") {
                            model.add(title: draft)
                            draft = ""
                        }
                        .accessibilityIdentifier("checklist.add")
                    }
                }
            }
            .navigationTitle("Factory Demo")
        }
        .accessibilityIdentifier("checklist.root")
    }
}
