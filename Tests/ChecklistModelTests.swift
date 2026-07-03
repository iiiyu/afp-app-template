import AppFeature
import Testing

@MainActor
struct ChecklistModelTests {
    @Test func addAppendsTrimmedItem() {
        let model = ChecklistModel()
        model.add(title: "  Write spec  ")
        #expect(model.items.map(\.title) == ["Write spec"])
    }

    @Test func addIgnoresBlankTitles() {
        let model = ChecklistModel()
        model.add(title: "   ")
        #expect(model.items.isEmpty)
    }

    @Test func toggleFlipsCompletionAndRemainingCount() {
        let item = ChecklistItem(title: "Ship it")
        let model = ChecklistModel(items: [item])
        #expect(model.remainingCount == 1)
        model.toggle(id: item.id)
        #expect(model.items[0].isDone)
        #expect(model.remainingCount == 0)
    }
}
