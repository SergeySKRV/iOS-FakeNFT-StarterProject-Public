import UIKit

struct UserProfile: Codable {
    let photo: Data?
    let name: String
    let description: String
    let website: String

    init(photo: UIImage, name: String, description: String, website: String) {
        self.photo = photo.pngData()
        self.name = name
        self.description = description
        self.website = website
    }
    
    func getPhoto() -> UIImage? {
        guard let photoData = photo else { return nil }
        return UIImage(data: photoData)
    }
}
