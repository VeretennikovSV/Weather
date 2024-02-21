import Foundation

protocol IWeatherCellViewModel {
    var isFavorite: Bool { get set }
    var cityName: String { get }
    var degreesText: String { get }
    var countryName: String { get }
    var currentConditionImageName: String { get }
    var currentConditionText: String { get }

    func updateFavoriteState()
    func updatedFavoriteState() -> Bool
    func getCityData() -> BulkCity
}

final class WeatherCellViewModel: IWeatherCellViewModel {
    private var favoritesRepo = Resolver.resolve(IFavoritesRepository.self)
    private var city: BulkCity
    private var cityIdentifier: String {
        city.query.q
    }

    var cityName: String {
        city.query.location.region
    }

    var degreesText: String {
        "\(Int(city.query.current.tempC.rounded()))°"
    }

    var countryName: String {
        city.query.location.country
    }

    var currentConditionImageName: String {
        city.query.current.condition?.icon ?? ""
    }

    var currentConditionText: String {
        city.query.current.condition?.text ?? ""
    }

    var isFavorite: Bool = false

    func updateFavoriteState() {
        isFavorite.toggle()
        setFavoritesStatus(value: isFavorite, key: cityIdentifier)
    }

    func updatedFavoriteState() -> Bool {
        UserDefaults.standard.bool(forKey: cityIdentifier)
    }

    func getCityData() -> BulkCity {
        city
    }

    private func setFavoritesStatus(value: Bool, key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
        favoritesRepo?.updateCity(city: key)
    }

    private func getFavoriteStatus(key: String) -> Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    init(city: BulkCity) {
        self.city = city
        isFavorite = getFavoriteStatus(key: cityIdentifier)
    }
}
