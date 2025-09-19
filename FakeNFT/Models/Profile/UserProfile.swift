import Foundation

/// Профиль пользователя, получаемый из API.
///
/// Содержит основные данные: имя, описание, сайт, аватар, список NFT и лайки.
struct UserProfile: Codable {
    /// ID пользователя.
    let id: String

    /// Имя.
    let name: String

    /// Описание (био).
    let description: String?

    /// Веб-сайт.
    let website: String

    /// URL-строка аватара (может быть `nil`).
    let avatar: String?

    /// ID NFT, принадлежащих пользователю.
    let nfts: [String]

    /// ID NFT, отмеченных лайком.
    var likes: Set<String>

    enum CodingKeys: String, CodingKey {
        case id, name, description, website, avatar, nfts, likes
    }
}
