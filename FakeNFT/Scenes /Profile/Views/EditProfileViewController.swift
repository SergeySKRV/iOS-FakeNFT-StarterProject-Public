import Kingfisher
import ProgressHUD
import UIKit


// MARK: - EditProfileViewController
final class EditProfileViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var profileImageView = makeProfileImageView()
    private lazy var cameraButton = makeCameraButton()
    private lazy var nameLabel = makeNameLabel()
    private lazy var nameTextField = makeNameTextField()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var descriptionTextView = makeDescriptionTextView()
    private lazy var websiteLabel = makeWebsiteLabel()
    private lazy var websiteTextField = makeWebsiteTextField()
    private lazy var saveButton = makeSaveButton()

    // MARK: - Properties
    private var presenter: EditProfilePresenterProtocol!
    private var userProfile: UserProfile?
    private var hasChanges = false
    weak var delegate: EditProfileViewControllerDelegate?
    var servicesAssembly: ServicesAssembly!
    private var avatarURLString: String?

    // MARK: - Lifecycle
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPresenter()
        presenter.viewDidLoad()
        addDismissKeyboardGesture()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .yaSecondary
        setupConstraints()
    }

    private func setupPresenter() {
        guard let servicesAssembly = self.servicesAssembly,
              let userProfile = self.userProfile else {
            assertionFailure("ServicesAssembly or UserProfile is not set")
            return
        }
        let userService = servicesAssembly.userService
        presenter = EditProfilePresenter(
            view: self,
            userProfile: userProfile,
            userService: userService
        )
    }

    private func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupConstraints() {
        addSubviews()
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            cameraButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 2),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 23),
            cameraButton.heightAnchor.constraint(equalToConstant: 23),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 160),

            websiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 50),

            saveButton.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor, constant: 152),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(cameraButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteLabel)
        view.addSubview(websiteTextField)
        view.addSubview(saveButton)
    }

    // MARK: - Actions
    @objc
    func backButtonTapped() {
        presenter.backButtonTapped()
    }

    @objc
    func saveButtonTapped() {
        presenter.saveButtonTapped()
    }

    @objc
    func cameraButtonTapped() {
        presenter.cameraButtonTapped()
    }

    @objc
    func handleTextFieldChange() {
        presenter.contentChanged()
    }

    @objc
    func handleTextViewChange() {
        presenter.contentChanged()
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        presenter.contentChanged()
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - EditProfilePresenterOutput
extension EditProfileViewController: EditProfilePresenterOutput {
    func updateProfileUI(_ profile: UserProfile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website

        if let avatarString = profile.avatar,
           let avatarURL = URL(string: avatarString) {
            profileImageView.kf.setImage(
                with: avatarURL,
                placeholder: UIImage(resource: .placeholderAvatar)
            )
        } else {
            profileImageView.image = UIImage(resource: .placeholderAvatar)
        }

        self.avatarURLString = profile.avatar
    }

    func showExitConfirmationAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("EditProfile.exitTitle", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.cancel", comment: ""),
            style: .cancel,
            handler: nil
        ))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.exitButton", comment: ""),
            style: .default,
            handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }
        ))
        present(alertController, animated: true)
    }

    func showPhotoOptionsAlert() { /* твой код */ }
    func showPhotoURLAlert() { /* твой код */ }

    func showLoader() { ProgressHUD.show() }
    func hideLoader() { ProgressHUD.dismiss() }
    func dismissViewController() { dismiss(animated: true) }

    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        presenter.loadImageFromURL(url, completion: completion)
    }

    func updateProfileImage(_ image: UIImage) { profileImageView.image = image }

    func saveUserProfileLocally(_ profile: UserProfile) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: "UserProfile")
        } catch {
            print("❌ Failed to save profile locally: \(error)")
        }
    }

    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Result<Bool, Error>) -> Void) {
        presenter.updateUserProfile(profile, completion: completion)
    }

    func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }

    func observeTextFieldsForChanges() {
        nameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        websiteTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        descriptionTextView.delegate = self
    }

    func getProfileImage() -> UIImage? { profileImageView.image }
    func getNameText() -> String? { nameTextField.text }
    func getDescriptionText() -> String? { descriptionTextView.text }
    func getWebsiteText() -> String? { websiteTextField.text }
    func setHasChanges(_ hasChanges: Bool) { self.hasChanges = hasChanges }
    func getHasChanges() -> Bool { hasChanges }
    func getAvatarURLString() -> String? { self.avatarURLString }
}
