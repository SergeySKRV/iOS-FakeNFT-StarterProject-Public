import Foundation

/// Пример PUT-запроса к API.
///
/// Использует метод `PUT` и отправляет тело запроса,
/// реализующее протокол `RequestBodyConvertible`.
struct ExamplePutRequest: NetworkRequest {
    /// Конечная точка запроса.
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/someMethod")
    }

    /// HTTP-метод запроса (в данном случае `PUT`).
    var httpMethod: HttpMethod = .put

    /// Тело запроса.
    var body: RequestBodyConvertible?
}

/// Пример тела запроса для `ExamplePutRequest`.
///
/// Содержит параметры, которые сериализуются
/// в словарь (`[String: String]`) для отправки.
struct ExampleRequestBody: RequestBodyConvertible {
    /// Первый параметр (будет отправлен как `param_1`).
    let param1: String

    /// Второй параметр (будет отправлен как `param_2`).
    let param2: String

    /// Ключи для сериализации в тело запроса.
    enum CodingKeys: String, CodingKey {
        case param1 = "param_1" // имя поля в запросе будет `param_1`
        case param2             // имя поля в запросе будет `param_2`
    }

    /// Возвращает тело как словарь для `application/x-www-form-urlencoded`.
    func asDictionary() -> [String: String] {
        [
            CodingKeys.param1.rawValue: param1,
            CodingKeys.param2.rawValue: param2
        ]
    }
}

/// Пример модели ответа на `ExamplePutRequest`.
///
/// Парсится автоматически с помощью `Decodable`.
struct ExamplePutResponse: Decodable {
    /// Имя ресурса.
    let name: String

    /// Список связанных устройств.
    let devices: [String]
}
