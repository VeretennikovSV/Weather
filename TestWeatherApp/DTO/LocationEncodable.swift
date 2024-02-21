import Foundation

// MARK: - Welcome
struct Locations: Codable {
    var locations: [Location]
}

// MARK: - Location
struct Location: Codable {
    let q: String
}


struct ExactLocation: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzId: String
    let localtimeEpoch: Int
    let localtime: String
}
