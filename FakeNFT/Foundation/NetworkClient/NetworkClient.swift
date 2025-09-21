import Foundation

// MARK: - Errors
/// Ошибки, которые может возвращать сетевой клиент.
///
/// Используются для обработки и диагностики проблем при выполнении HTTP-запросов.
enum NetworkClientError: Error {
    /// Сервер вернул код ответа, выходящий за пределы диапазона `200...299`.
    /// - Parameter Int: полученный HTTP статус-код.
    case httpStatusCode(Int)

    /// Ошибка при формировании или отправке `URLRequest`.
    /// - Parameter Error: исходная ошибка системы.
    case urlRequestError(Error)

    /// Ошибка внутри `URLSession` (например, отсутствует корректный `HTTPURLResponse`).
    case urlSessionError

    /// Ошибка при декодировании полученных данных в ожидаемую модель.
    case parsingError

    /// Ошибка соединения: "Connection reset by peer".
    /// Обычно означает, что сервер закрыл соединение преждевременно.
    case connectionReset
}

// MARK: - Public Protocol

protocol NetworkClientProtocol {
    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask?
}

extension NetworkClientProtocol {
    @discardableResult
    func send(
        request: NetworkRequest,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        send(
            request: request,
            completionQueue: .main,
            onResponse: onResponse
        )
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        send(
            request: request,
            type: type,
            completionQueue: .main,
            onResponse: onResponse
        )
    }
}

// MARK: - Client

struct DefaultNetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        let onResponse: (Result<Data, Error>) -> Void = { result in
            completionQueue.async {
                onResponse(result)
            }
        }

        guard let urlRequest = create(request: request) else { return nil }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error as NSError?, error.code == 54 {
                onResponse(.failure(NetworkClientError.connectionReset))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                onResponse(.failure(NetworkClientError.urlSessionError))
                return
            }

            guard 200 ..< 300 ~= response.statusCode else {
                onResponse(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                return
            }

            if let data = data {
                onResponse(.success(data))
            } else if let error = error {
                onResponse(.failure(NetworkClientError.urlRequestError(error)))
            } else {
                onResponse(.failure(NetworkClientError.urlSessionError))
            }
        }

        task.resume()
        return DefaultNetworkTask(dataTask: task)
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        if let dto = request.body {
            if let json = dto.asJSONData() {
                urlRequest.httpBody = json
                urlRequest.setValue(dto.contentType, forHTTPHeaderField: "Content-Type")
            } else {
                let dict = dto.asDictionary()
                var components = URLComponents()
                components.queryItems = dict.map { URLQueryItem(name: $0.key, value: $0.value) }
                urlRequest.httpBody = components.query?.data(using: .utf8)
                urlRequest.setValue(dto.contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        return urlRequest
    }

    private func parse<T: Decodable>(
        data: Data,
        type _: T.Type,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}

// MARK: - HTTP
/// HTTP-методы, поддерживаемые сетевым клиентом.
///
/// Используются для указания типа запроса при формировании `URLRequest`.
/// Основаны на стандартных методах протокола HTTP 1.1.
enum HttpMethod: String {
    /// Используется для получения данных с сервера (чтение).
    case get = "GET"

    /// Используется для отправки данных на сервер (создание ресурса).
    case post = "POST"

    /// Используется для обновления существующего ресурса.
    /// В отличие от `PATCH`, предполагает полную замену ресурса.
    case put = "PUT"

    /// Используется для удаления ресурса с сервера.
    case delete = "DELETE"
}
