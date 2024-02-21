import Foundation

protocol IGetCitiesByNamesUseCase {
    func getCities(_ cities: [String], result: @escaping FetchResult<BulkCities>)
}

extension NetworkService: IGetCitiesByNamesUseCase {
    func getCities(_ cities: [String], result: @escaping FetchResult<BulkCities>) {
        let locationsArray = cities.map { Location(q: $0) }
        let locations = Locations(locations: locationsArray)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(locations) else { return }

        post(url: "&q=bulk", body: jsonData, completion: result)
    }
}
