import UIKit

protocol UserProfileService {
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
    func saveUserProfileLocally(_ profile: UserProfile) -> Bool
    func loadUserProfileLocally() -> UserProfile?
}

final class UserProfileServiceImpl: UserProfileService {
    
    // MARK: - Public Methods
    func fetchUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        if let localProfile = loadUserProfileLocally() {
            completion(.success(localProfile))
            return
        }
        
            let mockProfile = UserProfile(
                photo: UIImage(named: "userPic") ?? UIImage(systemName: "person.circle") ?? UIImage(),
                name: "Joaquin Phoenix",
                description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
                website: "Joaquin Phoenix.com"
            )
            
            DispatchQueue.main.async {
                completion(.success(mockProfile))
            }
    }
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let saved = self.saveUserProfileLocally(profile)
            
            DispatchQueue.main.async {
                if saved {
                    completion(.success(true))
                } else {
                    completion(.failure(NSError(domain: "SaveError", code: 0, userInfo: nil)))
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
            print("Ошибка сохранения профиля: \(error)")
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
            print("Ошибка загрузки профиля: \(error)")
            return nil
        }
    }
}
