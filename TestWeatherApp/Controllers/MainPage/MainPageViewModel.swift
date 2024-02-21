import Foundation

protocol WeatherSearchable {
    func searchFor(city: String)
}

class WeatherViewModel: IWeatherViewModel, WeatherSearchable {
    var bulkCities: [BulkCity] = []
    let getCitiesUserCase = Resolver.resolve(IGetCitiesByNamesUseCase.self)
    var currentPage = 1
    private var cities = citiesStub

    func loadCities(refreshing: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        getCitiesUserCase?.getCities(Array(cities[getPageItemsRange(refreshing: refreshing)]), result: { result in
            switch result {
            case let .success(cities):
                if refreshing {
                    self.didTriggerPullToRefresh()
                }
                self.currentPage += 1
                self.bulkCities += cities.bulk
                completion(.success(Void()))

            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    func getCellModel(at index: Int) -> BulkCity {
        bulkCities[index]
    }

    func numberOfCities() -> Int {
        bulkCities.count
    }

    func getPageItemsRange(refreshing: Bool) -> ClosedRange<Int> {
        guard !bulkCities.isEmpty else { return 0...min(cities.count - 1, 9) }
        let maxRange = min(cities.count, currentPage * 10)
        if !refreshing {
            return bulkCities.count...maxRange - 1
        } else {
            return 0...min(cities.count - 1, 9)
        }
    }

    func searchFor(city: String) {
        cities = city.isEmpty ? citiesStub : city.components(separatedBy: ",")
        currentPage = 1
        bulkCities.removeAll()
    }

    func didTriggerPullToRefresh() {
        cities = citiesStub
        currentPage = 1
        bulkCities.removeAll()
    }
}
