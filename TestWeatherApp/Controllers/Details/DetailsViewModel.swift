import Foundation

protocol IDetailsViewModel {
    var cityName: String { get }
    var degreesText: String { get }
    var feelslikeText: String { get }
    var countryName: String { get }
    var currentConditionImageName: String { get }
    var currentConditionText: String { get }
    var pressure: String { get }
    var windSpeed: String { get }
    var humidity: String { get }
}

final class DetailsViewModel: IDetailsViewModel {
    private let city: BulkCity

    var cityName: String {
        city.query.location.region
    }

    var degreesText: String {
        "\(Int(city.query.current.tempC.rounded()))°"
    }

    var feelslikeText: String {
        "Feels like - \(Int(city.query.current.feelslikeC?.rounded() ?? 0))"
    }

    var countryName: String {
        city.query.location.country
    }

    var regionName: String {
        city.query.location.region
    }

    var pressure: String {
        "\(Int(city.query.current.pressureIn?.rounded() ?? 0)) mm" // Я хз как там давление передается
    }

    var windSpeed: String {
        "\(Int(city.query.current.windKph?.rounded() ?? 0)) kph"
    }

    var humidity: String {
        "\(Int(city.query.current.humidity?.rounded() ?? 0))%"
    }

    var currentConditionImageName: String {
        city.query.current.condition?.icon ?? ""
    }

    var currentConditionText: String {
        city.query.current.condition?.text ?? ""
    }

    init(city: BulkCity) {
        self.city = city
    }
}
