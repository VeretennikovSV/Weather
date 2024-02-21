import Foundation

protocol FavoriteUpdateble {
    func restoreState()
}

final class FavoritesCitiesWeatherViewModel: WeatherViewModel {
    private var favoritesRepository = Resolver.resolve(IFavoritesRepository.self)
    private var favoriteCities: [String] {
        favoritesRepository?.getFavoriteCities().sorted() ?? []
    }

    override func loadCities(refreshing: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !favoriteCities.isEmpty else {
            self.bulkCities.removeAll()
            completion(.success(()))
            return
        }
        getCitiesUserCase?.getCities(Array(favoriteCities[getPageItemsRange(refreshing: refreshing)]), result: { result in
            switch result {
            case let .success(cities):
                self.bulkCities = cities.bulk
                completion(.success(()))

            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    override func getPageItemsRange(refreshing: Bool) -> ClosedRange<Int> {
        0...favoriteCities.count - 1
    }
}
