//
//  UserProfileService.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 10.09.2025.
//

import Foundation

// MARK: - UserProfileService
protocol UserProfileService {
    // MARK: - Public Methods
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
    func saveUserProfileLocally(_ profile: UserProfile) -> Bool
    func loadUserProfileLocally() -> UserProfile?
}
