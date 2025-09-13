//
//  EditProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//
import UIKit

// MARK: - View Contract
protocol EditProfilePresenterOutput: AnyObject {
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
    func getAvatarURLString() -> String?
}

// MARK: - Presenter Lifecycle
protocol EditProfilePresenterLifecycle {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

// MARK: - Presenter Actions
protocol EditProfilePresenterActions {
    func backButtonTapped()
    func saveButtonTapped()
    func cameraButtonTapped()
    func contentChanged()
    func photoDeleted()
    func photoURLChanged(_ url: URL)
}

// MARK: - Presenter UI Operations
protocol EditProfilePresenterUIOperations {
    func showExitConfirmationAlert()
    func showPhotoOptionsAlert()
    func showPhotoURLAlert()
    func showLoader()
    func hideLoader()
    func dismissViewController()
    func showAlert(title: String, message: String?)
    func updateProfileImage(_ image: UIImage)
    func setupNavigationBar()
    func observeTextFieldsForChanges()
}

// MARK: - Presenter Data Operations
protocol EditProfilePresenterDataOperations {
    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void)
    func saveUserProfileLocally(_ profile: UserProfile)
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void)
}

// MARK: - Main Presenter Protocol
protocol EditProfilePresenterProtocol:
    EditProfilePresenterLifecycle,
    EditProfilePresenterActions,
    EditProfilePresenterUIOperations,
    EditProfilePresenterDataOperations {
    init(view: EditProfilePresenterOutput, userProfile: UserProfile, userService: UserProfileService, imageLoaderService: ImageLoaderService)
}
