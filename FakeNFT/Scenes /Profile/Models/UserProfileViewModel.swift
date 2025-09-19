//
//  UserProfileViewModel.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 19.09.2025.
//

import UIKit

/// Вью-модель для экрана профиля.
///
/// Объединяет данные `UserProfile` и картинку аватара.
struct UserProfileViewModel {
    let id: String
    let name: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: Set<String>
    var avatarImage: UIImage?
    var avatarURL: String?

    init(profile: UserProfile, avatarImage: UIImage? = nil) {
        self.id = profile.id
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website
        self.nfts = profile.nfts
        self.likes = profile.likes
        self.avatarURL = profile.avatar
        self.avatarImage = avatarImage
    }

    /// Проверка, лайкнут ли NFT.
    func isLiked(nftId: String) -> Bool {
        likes.contains(nftId)
    }
}
