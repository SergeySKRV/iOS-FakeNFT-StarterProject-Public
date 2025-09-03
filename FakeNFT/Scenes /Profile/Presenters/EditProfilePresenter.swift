import UIKit
import ProgressHUD

protocol EditProfilePresenterView: AnyObject {
    func updateProfileUI(_ profile: UserProfile)
    func showExitConfirmationAlert()
    func showPhotoOptionsAlert()
    func showPhotoURLAlert()
    func showLoader()
    func hideLoader()
    func dismissViewController()
    func showAlert(title: String, message: String?)
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
    func updateProfileImage(_ image: UIImage)
    func saveUserProfileLocally(_ profile: UserProfile)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
    func setupNavigationBar()
    func observeTextFieldsForChanges()
    func getProfileImage() -> UIImage?
    func getNameText() -> String?
    func getDescriptionText() -> String?
    func getWebsiteText() -> String?
    func setHasChanges(_ hasChanges: Bool)
    func getHasChanges() -> Bool
}

protocol EditProfilePresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func backButtonTapped()
    func saveButtonTapped()
    func cameraButtonTapped()
    func handleTextFieldChange()
    func handleTextViewChange()
    func textViewDidChange(_ textView: UITextView)
    func showExitConfirmationAlert()
    func showPhotoOptionsAlert()
    func showPhotoURLAlert()
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
    func updateProfileImage(_ image: UIImage)
    func saveUserProfileLocally(_ profile: UserProfile)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
    func photoDeleted()
    func photoURLChanged(_ url: URL)
}

class EditProfilePresenter: EditProfilePresenterProtocol {
    
    // MARK: - Properties
    private weak var view: EditProfilePresenterView?
    private let userService: UserProfileService
    private var userProfile: UserProfile?
    private var hasChanges = false
    
    // MARK: - Initialization
    init(view: EditProfilePresenterView, userProfile: UserProfile, userService: UserProfileService) {
        self.view = view
        self.userProfile = userProfile
        self.userService = userService
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        view?.updateProfileUI(userProfile!)
        view?.setupNavigationBar()
        view?.observeTextFieldsForChanges()
    }
    
    func viewWillAppear() {
        
    }
    
    func viewWillDisappear() {
        
    }
    
    func backButtonTapped() {
        if view?.getHasChanges() ?? false {
            view?.showExitConfirmationAlert()
        } else {
            view?.dismissViewController()
        }
    }
    
    func saveButtonTapped() {
        guard let currentUser = userProfile else { return }
        
        let updatedProfile = UserProfile(
            photo: view?.getProfileImage() ?? currentUser.getPhoto() ?? UIImage(),
            name: view?.getNameText() ?? currentUser.name,
            description: view?.getDescriptionText() ?? currentUser.description,
            website: view?.getWebsiteText() ?? currentUser.website
        )
        
        view?.updateUserProfile(updatedProfile) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.view?.showLoader()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.view?.hideLoader()
                        self?.userProfile = updatedProfile
                        self?.view?.dismissViewController()
                    }
                }
            case .failure(let error):
                print("Ошибка сохранения профиля: \(error)")
                DispatchQueue.main.async {
                    self?.view?.hideLoader()
                }
            }
        }
    }
    
    func cameraButtonTapped() {
        view?.showPhotoOptionsAlert()
    }
    
    func handleTextFieldChange() {
        view?.setHasChanges(true)
    }
    
    func handleTextViewChange() {
        view?.setHasChanges(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        view?.setHasChanges(true)
    }
    
    func showExitConfirmationAlert() {
        view?.showExitConfirmationAlert()
    }
    
    func showPhotoOptionsAlert() {
        view?.showPhotoOptionsAlert()
    }
    
    func showPhotoURLAlert() {
        view?.showPhotoURLAlert()
    }
    
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    func updateProfileImage(_ image: UIImage) {
        view?.updateProfileImage(image)
        view?.setHasChanges(true)
    }
    
    func saveUserProfileLocally(_ profile: UserProfile) {
        view?.saveUserProfileLocally(profile)
    }
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void) {
        view?.updateUserProfile(profile, completion: completion)
    }
    
    func photoDeleted() {
        view?.setHasChanges(true)
    }
    
    func photoURLChanged(_ url: URL) {
        view?.setHasChanges(true)
    }
}
