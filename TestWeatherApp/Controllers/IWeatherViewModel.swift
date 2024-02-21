import Foundation

protocol IWeatherViewModel: AnyObject {
    func loadCities(refreshing: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func getCellModel(at index: Int) -> BulkCity
    func numberOfCities() -> Int
    func didTriggerPullToRefresh()
}
