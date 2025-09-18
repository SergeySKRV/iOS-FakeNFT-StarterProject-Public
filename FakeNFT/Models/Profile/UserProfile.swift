import UIKit

// MARK: - UserProfile

struct UserProfile: Codable {
    let id: String
    let name: String
    let description: String?
    let website: String
    private let avatarString: String?
    let nfts: [String]
    var likes: [String]

    private var avatarImage: UIImage?

    var avatar: URL? {
        guard let avatarString = avatarString else { return nil }
        return URL(string: avatarString)
    }

    init(id: String, name: String, description: String?, website: String, avatarURLString: String?, nfts: [String], likes: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.website = website
        self.avatarString = avatarURLString
        self.nfts = nfts
        self.likes = likes
    }

    init(id: String, name: String, description: String?, website: String, avatar: UIImage?, nfts: [String], likes: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.website = website
        self.avatarString = avatar?.pngDataURL()?.absoluteString
        self.nfts = nfts
        self.likes = likes
        self.avatarImage = avatar
    }

    init(photo: UIImage?, name: String, description: String, website: String) {
        self.id = "1"
        self.name = name
        self.description = description
        self.website = website
        self.avatarString = nil
        self.nfts = []
        self.likes = []
        self.avatarImage = photo
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case website
        case avatarString = "avatar"
        case nfts
        case likes
    }

    func getAvatarImage(completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = avatarImage {
            completion(cachedImage)
            return
        }
        guard let avatarURL = avatar else {
            completion(nil)
            return
        }

        URLSession.shared
            .dataTask(with: avatarURL) { data, _, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            .resume()
    }

    func getCachedAvatarImage() -> UIImage? {
        avatarImage
    }

    func settingAvatarImage(_ image: UIImage) -> UserProfile {
        var updatedProfile = self
        updatedProfile.avatarImage = image
        return updatedProfile
    }

    mutating func addToLikes(nftId: String) {
        if !likes.contains(nftId) {
            likes.append(nftId)
        }
    }

    mutating func removeFromLikes(nftId: String) {
        likes.removeAll { $0 == nftId }
    }

    func isLiked(nftId: String) -> Bool {
        likes.contains(nftId)
    }
}

// MARK: - UIImage Extension

extension UIImage {
    func pngDataURL() -> URL? {
        guard let data = pngData() else { return nil }
        return URL(string: "data:image/png;base64,\(data.base64EncodedString())")
    }
}
