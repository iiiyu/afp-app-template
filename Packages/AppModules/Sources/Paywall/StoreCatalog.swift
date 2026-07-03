import StoreKit

/// StoreKit 2 product catalog. scaffold-from-spec fills the product IDs from the
/// spec package; a matching .storekit configuration file backs local testing.
public enum StoreCatalog {
    public static let productIDs: [String] = []

    public static func products() async throws -> [Product] {
        guard !productIDs.isEmpty else { return [] }
        return try await Product.products(for: productIDs)
    }
}
