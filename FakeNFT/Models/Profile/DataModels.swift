import UIKit

// MARK: - Data Models
struct ProfileSection {
    let title: String
    let items: [ProfileItem]
}

struct ProfileItem {
    let title: String
    let subtitle: String
}

struct UserProfile {
    let photo: UIImage
    let name: String
    let description: String
    let website: String
}
