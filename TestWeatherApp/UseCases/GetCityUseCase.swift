import Foundation

protocol IGetCityUseCase {
    func getCityDataByName(_ name: String, result: @escaping FetchResult<CityData>)
}

extension NetworkService: IGetCityUseCase {
    func getCityDataByName(_ name: String, result: @escaping FetchResult<CityData>) {
        get(url: "&q=\(name)", completion: result)
    }
}
