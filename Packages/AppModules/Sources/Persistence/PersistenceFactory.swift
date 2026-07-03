import SwiftData

/// SwiftData container factory. Apps declare their @Model types and get a
/// container; tests use the in-memory variant so gates never touch real storage.
public enum PersistenceFactory {
    public static func container(
        for types: [any PersistentModel.Type],
        inMemory: Bool = false
    ) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: Schema(types), configurations: [configuration])
    }
}
