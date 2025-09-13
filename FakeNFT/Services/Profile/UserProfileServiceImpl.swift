import UIKit

final class UserProfileServiceImpl: UserProfileService {
    // MARK: - Properties
    private let networkClient: NetworkClient

    // MARK: - Initialization
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Public Methods
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let request = UserProfileRequest()
        networkClient.send(request: request, type: UserProfile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                _ = self?.saveUserProfileLocally(profile)
                DispatchQueue.main.async {
                    completion(.success(profile))
                }
            case .failure(let error):
                if let localProfile = self?.loadUserProfileLocally() {
                    DispatchQueue.main.async {
                        completion(.success(localProfile))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void) {
        let updateDTO = UserProfileUpdateDTO(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            avatar: profile.avatar?.absoluteString
        )
        let updateRequest = UpdateUserProfileRequest(updateData: updateDTO)
        networkClient.send(request: updateRequest) { [weak self] result in
            switch result {
            case .success:
                let saveResult = self?.saveUserProfileLocally(profile) ?? false
                DispatchQueue.main.async {
                    completion(.success(saveResult))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func saveUserProfileLocally(_ profile: UserProfile) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: "UserProfile")
            return true
        } catch {
            return false
        }
    }

    func loadUserProfileLocally() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: "UserProfile") else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let profile = try decoder.decode(UserProfile.self, from: data)
            return profile
        } catch {
            UserDefaults.standard.removeObject(forKey: "UserProfile")
            return nil
        }
    }
}
