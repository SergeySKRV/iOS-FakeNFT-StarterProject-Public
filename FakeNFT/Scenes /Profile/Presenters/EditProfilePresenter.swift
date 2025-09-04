import UIKit
import ProgressHUD

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    // MARK: - Properties
    private weak var view: EditProfilePresenterOutput?
    private let userService: UserProfileService
    private let imageLoaderService: ImageLoaderService
    private var userProfile: UserProfile?
    private var hasChanges = false
    
    // MARK: - Initialization
    required init(view: EditProfilePresenterOutput,
                 userProfile: UserProfile,
                 userService: UserProfileService,
                 imageLoaderService: ImageLoaderService = ImageLoaderServiceImpl()) {
        self.view = view
        self.userProfile = userProfile
        self.userService = userService
        self.imageLoaderService = imageLoaderService
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        view?.updateProfileUI(userProfile!)
        view?.setupNavigationBar()
        view?.observeTextFieldsForChanges()
    }
    
    func viewWillAppear() {
    }
    
    func viewWillDisappear() {
    }
    
    // MARK: - Actions
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
      
        userService.updateUserProfile(updatedProfile) { [weak self] result in
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
 
    func contentChanged() {
        view?.setHasChanges(true)
    }
    
    func photoDeleted() {
        view?.setHasChanges(true)
    }
    
    func photoURLChanged(_ url: URL) {
        view?.setHasChanges(true)
    }
    
    // MARK: - UI Operations
    func showExitConfirmationAlert() {
        view?.showExitConfirmationAlert()
    }
    
    func showPhotoOptionsAlert() {
        view?.showPhotoOptionsAlert()
    }
    
    func showPhotoURLAlert() {
        view?.showPhotoURLAlert()
    }
    
    func showLoader() {
        view?.showLoader()
    }
    
    func hideLoader() {
        view?.hideLoader()
    }
    
    func dismissViewController() {
        view?.dismissViewController()
    }
    
    func showAlert(title: String, message: String?) {
        view?.showAlert(title: title, message: message)
    }
    
    func updateProfileImage(_ image: UIImage) {
        view?.updateProfileImage(image)
        view?.setHasChanges(true)
    }
    
    func setupNavigationBar() {
        view?.setupNavigationBar()
    }
    
    func observeTextFieldsForChanges() {
        view?.observeTextFieldsForChanges()
    }
    
    // MARK: - Data Operations
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        imageLoaderService.loadImage(from: url, completion: completion)
    }
    
    func saveUserProfileLocally(_ profile: UserProfile) {
        view?.saveUserProfileLocally(profile)
    }
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void) {
        view?.updateUserProfile(profile, completion: completion)
    }
}
