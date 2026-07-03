import Foundation
import Observation

public struct ChecklistItem: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var isDone: Bool

    public init(id: UUID = UUID(), title: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

/// Demo feature model. Exists so every gate in verify.sh exercises something
/// real; scaffold-from-spec replaces AppFeature wholesale.
@MainActor
@Observable
public final class ChecklistModel {
    public private(set) var items: [ChecklistItem]

    public init(items: [ChecklistItem] = []) {
        self.items = items
    }

    public var remainingCount: Int {
        items.count(where: { !$0.isDone })
    }

    public func add(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(ChecklistItem(title: trimmed))
    }

    public func toggle(id: ChecklistItem.ID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].isDone.toggle()
    }
}
