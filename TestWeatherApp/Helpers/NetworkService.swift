import Foundation

typealias FetchResult<T> = (Result<T, Error>) -> Void

enum HttpMethod: String {
    case get
    case post
}

enum NetworkError: Error {
    case missedData
    case decodingError
}

protocol INetworkService {
    var baseApi: String { get }
    func get<T: Decodable>(url: String, completion: @escaping FetchResult<T>)
}

final class NetworkService: INetworkService {
    private let apiKey = "9b005dc009e54b77b7694241242002" // Не совсем приватный, но чуть чуть приватный
    private let decoder = JSONDecoder()
    var baseApi: String

    func get<T: Decodable>(url: String, completion: @escaping FetchResult<T>) {
        guard let url = setUrl(urlString: url) else { return }
        let request = baseRequest(url: url)
        dataTask(request: request, completion: completion)
    }

    func post<T: Decodable>(url: String, body: Data?, completion: @escaping FetchResult<T>) {
        guard let url = setUrl(urlString: url) else { return }
        var request = baseRequest(url: url)
        request.httpMethod = "POST"
        if let body {
            request.httpBody = body
        }
        dataTask(request: request, completion: completion)
    }

    private func baseRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func dataTask<T: Decodable>(request: URLRequest, completion: @escaping FetchResult<T>) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error { completion(.failure(error)) }
            guard let data else {
                completion(.failure(NetworkError.missedData))
                return
            }

            do {
                let model = try self.decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                completion(.failure(NetworkError.decodingError))
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkError.decodingError))
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkError.decodingError))
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkError.decodingError))
            } catch {
                print("error: ", error)
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }

    private func setUrl(urlString: String) -> URL? {
        URL(string: "\(baseApi)\(urlString)")
    }

    init(baseApi: String = "https://api.weatherapi.com/v1/current.json?key=9b005dc009e54b77b7694241242002") {
        self.baseApi = baseApi
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
