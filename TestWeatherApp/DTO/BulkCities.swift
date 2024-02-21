import Foundation

struct BulkCities: Codable {
    let bulk: [BulkCity]
}

// MARK: - Bulk
struct BulkCity: Codable {
    let query: Query
}

// MARK: - Query
struct Query: Codable {
    let customId, q: String
    let location: ExactLocation
    let current: CityCondition
}
