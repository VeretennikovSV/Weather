import Foundation

struct CityData: Codable {
    let current: CityCondition
}

struct CityCondition: Codable {
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let tempC, tempF: Double
    let isDay: Int?
    let condition: Condition?
    let windMph, windKph: Double?
    let windDegree: Double?
    let windDir: String?
    let pressureMb: Double?
    let pressureIn: Double?
    let precipMm, precipIn, humidity, cloud: Double?
    let feelslikeC, feelslikeF: Double?
    let visKm, visMiles, uv: Double?
    let gustMph, gustKph: Double?
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String?
    let code: Int?
}
