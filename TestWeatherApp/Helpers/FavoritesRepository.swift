import Foundation

protocol IFavoritesRepository {
    func getFavoriteCities() -> Set<String>
    func updateCity(city: String)
}

final class FavoritesRepository: IFavoritesRepository {
    private let key = "Favorites"
    private let container = UserDefaults.standard

    func getFavoriteCities() -> Set<String> {
        guard let data = container.data(forKey: key),
              let value = try? JSONDecoder().decode(Set<String>.self, from: data) else { return [] }
        return value
    }

    func updateCity(city: String) {
        var cities = getFavoriteCities()
        if !container.bool(forKey: city) {
            cities.remove(city)
        } else {
            cities.insert(city)
        }
        let decoded = try? JSONEncoder().encode(cities)
        container.set(decoded, forKey: key)
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
}
