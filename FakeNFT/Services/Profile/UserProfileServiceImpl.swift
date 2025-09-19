import Foundation

// MARK: - UserProfileServiceImpl
final class UserProfileServiceImpl: UserProfileService {
    // MARK: - Properties
    private let networkClient: NetworkClientProtocol

    // MARK: - Lifecycle
    init(networkClient: NetworkClientProtocol) {
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
        let updateDTO = UserProfileUpdateRequestBody(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            avatar: profile.avatar
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

    func updateUserLikes(
        nftId: String,
        isLiked: Bool,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        fetchUserProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(var profile):
                // Обновляем локально (оптимистично)
                if isLiked {
                    profile.likes.insert(nftId)
                } else {
                    profile.likes.remove(nftId)
                }

                // Сохраняем локально сразу
                let saveResult = self.saveUserProfileLocally(profile)

                // Отправляем обновление на сервер
                let likesUpdateRequest = UpdateUserProfileRequest(likes: Array(profile.likes))
                self.networkClient.send(request: likesUpdateRequest) { updateResult in
                    DispatchQueue.main.async {
                        switch updateResult {
                        case .success:
                            completion(.success(saveResult)) // всё ок
                        case .failure(let error):
                            // Сервер не принял, но UI не откатываем
                            completion(.failure(error))
                        }
                    }
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
            print("Failed to save profile locally: \(error)")
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
            print("Failed to load profile locally: \(error)")
            UserDefaults.standard.removeObject(forKey: "UserProfile")
            return nil
        }
    }
}
