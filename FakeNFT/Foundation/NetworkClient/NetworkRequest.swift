import Foundation

// MARK: - NetworkRequest
/// Базовый протокол для сетевого запроса.
///
/// Определяет:
/// - конечную точку (`endpoint`);
/// - HTTP-метод (`httpMethod`);
/// - тело запроса (`body`).
protocol NetworkRequest {
    /// URL конечной точки.
    var endpoint: URL? { get }

    /// HTTP-метод запроса.
    var httpMethod: HttpMethod { get }

    /// Тело запроса (может быть `nil`, если тело не требуется).
    var body: RequestBodyConvertible? { get }
}

// MARK: - Default Implementation
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var body: RequestBodyConvertible? { nil }
}

// MARK: - RequestBodyConvertible
/// Протокол для описания тела HTTP-запроса.
///
/// Используется для подготовки данных в формате `application/x-www-form-urlencoded`
/// или `application/json`.
///
/// По умолчанию:
/// - сериализация идёт через `asDictionary()`;
/// - `asJSONData()` возвращает `nil`;
/// - `contentType` равен `"application/x-www-form-urlencoded"`.
protocol RequestBodyConvertible {
    /// Преобразует тело запроса в словарь (`x-www-form-urlencoded`).
    func asDictionary() -> [String: String]

    /// Возвращает сериализованные данные для `application/json`.
    /// Если реализовано, то используется вместо `asDictionary()`.
    func asJSONData() -> Data?

    /// MIME-тип содержимого тела (`application/json`, `application/x-www-form-urlencoded` и т.д.).
    var contentType: String { get }
}

// MARK: - Default Implementation
extension RequestBodyConvertible {
    func asJSONData() -> Data? { nil }

    var contentType: String { "application/x-www-form-urlencoded" }
}
