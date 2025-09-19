import Foundation

/// Колбэк для выполнения Example PUT-запроса.
/// Возвращает результат с моделью `ExamplePutResponse` или ошибкой.
typealias ExamplePutCompletion = (Result<ExamplePutResponse, Error>) -> Void

// MARK: - ExamplePutService

/// Сервис для отправки тестового PUT-запроса.
protocol ExamplePutService {
    /// Отправляет PUT-запрос с параметрами.
    /// - Parameters:
    ///   - param1: Первый параметр (будет сериализован в поле `param_1`).
    ///   - param2: Второй параметр (будет сериализован в поле `param_2`).
    ///   - completion: Колбэк с результатом (`ExamplePutResponse` или `Error`).
    func sendExamplePutRequest(
        param1: String,
        param2: String,
        completion: @escaping ExamplePutCompletion
    )
}

// MARK: - ExamplePutServiceImpl

/// Реализация `ExamplePutService`, использующая `NetworkClientProtocol`.
final class ExamplePutServiceImpl: ExamplePutService {
    // MARK: - Properties

    /// Сетевой клиент для выполнения HTTP-запросов.
    private let networkClient: NetworkClientProtocol

    // MARK: - Initialization

    /// Создаёт сервис с внедрённым сетевым клиентом.
    /// - Parameter networkClient: Реализация `NetworkClientProtocol`.
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    // MARK: - Public Methods

    func sendExamplePutRequest(
        param1: String,
        param2: String,
        completion: @escaping ExamplePutCompletion
    ) {
        // DTO с параметрами
        let body = ExampleRequestBody(param1: param1, param2: param2)

        // Формирование запроса
        let request = ExamplePutRequest(body: body)

        // Отправка запроса через сетевой клиент
        networkClient.send(request: request, type: ExamplePutResponse.self) { result in
            switch result {
            case .success(let putResponse):
                completion(.success(putResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
