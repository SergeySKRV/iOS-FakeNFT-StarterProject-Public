import UIKit
import ProgressHUD
import Kingfisher

// MARK: - EditProfileViewController
final class EditProfileViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .placeholderAvatar)
        return imageView
    }()

    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        let cameraImage = UIImage(resource: .cameraPic).withRenderingMode(.alwaysTemplate)
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .yaPrimary
        button.backgroundColor = .yaLightGray
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.nameLabel", comment: "")
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yaLightGray
        textField.layer.cornerRadius = 12
        textField.text = ""
        textField.font = Fonts.sfProRegular17
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.descriptionLabel", comment: "")
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .yaLightGray
        textView.layer.cornerRadius = 12
        textView.text = ""
        textView.font = Fonts.sfProRegular17
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("EditProfile.websiteLabel", comment: "")
        return label
    }()

    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yaLightGray
        textField.layer.cornerRadius = 12
        textField.text = ""
        textField.font = Fonts.sfProRegular17
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("EditProfile.save", comment: ""), for: .normal)
        button.titleLabel?.font = Fonts.sfProBold17
        button.setTitleColor(.yaSecondary, for: .normal)
        button.backgroundColor = .yaPrimary
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupConstraints()
    }

    private func updateUI() {
        guard let user = userProfile else { return }
        nameTextField.text = user.name
        descriptionTextView.text = user.description
        websiteTextField.text = user.website
        if let avatarURL = user.avatar, !avatarURL.absoluteString.isEmpty {
            profileImageView.kf.setImage(with: avatarURL, placeholder: UIImage(resource: .placeholderAvatar))
        } else {
            profileImageView.image = UIImage(resource: .placeholderAvatar)
        }
        profileImageView.image = user.getCachedAvatarImage() ?? UIImage(resource: .placeholderAvatar)
    }

    private func setupPresenter() {
        guard let servicesAssembly = self.servicesAssembly else {
            assertionFailure("ServicesAssembly is not set")
            return
        }
        let userService = servicesAssembly.userService
        guard let userProfile = userProfile else {
            return
        }
        presenter = EditProfilePresenter(
            view: self,
            userProfile: userProfile,
            userService: userService
        )
    }

    private func setupConstraints() {
        view.addSubview(profileImageView)
        view.addSubview(cameraButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteLabel)
        view.addSubview(websiteTextField)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            cameraButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 2),
            cameraButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0),
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
            saveButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    // MARK: - Actions
    @objc private func backButtonTapped() {
        presenter.backButtonTapped()
    }

    @objc private func saveButtonTapped() {
        presenter.saveButtonTapped()
    }

    @objc private func cameraButtonTapped() {
        presenter.cameraButtonTapped()
    }

    @objc private func handleTextFieldChange() {
        presenter.contentChanged()
    }

    @objc private func handleTextViewChange() {
        presenter.contentChanged()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - EditProfilePresenterOutput
extension EditProfileViewController: EditProfilePresenterOutput {
    func updateProfileUI(_ profile: UserProfile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        websiteTextField.text = profile.website
        if let avatarURL = profile.avatar, !avatarURL.absoluteString.isEmpty {
             profileImageView.kf.setImage(with: avatarURL, placeholder: UIImage(resource: .placeholderAvatar))
        } else {
             profileImageView.image = UIImage(resource: .placeholderAvatar)
        }
        self.avatarURLString = profile.avatar?.absoluteString
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

    func showPhotoOptionsAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("EditProfile.photoTitle", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.photoChange", comment: ""),
            style: .default,
            handler: { [weak self] _ in
                self?.showPhotoURLAlert()
            }
        ))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.photoDelete", comment: ""),
            style: .destructive,
            handler: { [weak self] _ in
                self?.profileImageView.image = UIImage(resource: .placeholderAvatar)
                self?.avatarURLString = nil
                self?.presenter.photoDeleted()
            }
        ))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.photoCancel", comment: ""),
            style: .cancel,
            handler: nil
        ))
        present(alertController, animated: true)
    }

    func showPhotoURLAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("EditProfile.photoUrlTitle", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("EditProfile.photoUrlPlaceholder", comment: "")
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.photoCancel", comment: ""),
            style: .cancel,
            handler: nil
        ))
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("EditProfile.save", comment: ""),
            style: .default,
            handler: { [weak self] _ in
                if let textField = alertController.textFields?.first,
                   let urlString = textField.text,
                   let url = URL(string: urlString) {
                    self?.loadImageFromURL(url) { [weak self] image in
                        DispatchQueue.main.async {
                            if let loadedImage = image {
                                self?.profileImageView.image = loadedImage
                                self?.avatarURLString = urlString
                                self?.presenter.photoURLChanged(url)
                            }
                        }
                    }
                }
            }
        ))
        present(alertController, animated: true)
    }

    func showLoader() {
        ProgressHUD.show()
    }

    func hideLoader() {
        ProgressHUD.dismiss()
    }

    func dismissViewController() {
        dismiss(animated: true)
    }

    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func loadImageFromURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        presenter.loadImageFromURL(url, completion: completion)
    }

    func updateProfileImage(_ image: UIImage) {
        profileImageView.image = image
    }

    func saveUserProfileLocally(_ profile: UserProfile) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: "UserProfile")
        } catch {
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

    func getProfileImage() -> UIImage? {
        return profileImageView.image
    }

    func getNameText() -> String? {
        return nameTextField.text
    }

    func getDescriptionText() -> String? {
        return descriptionTextView.text
    }

    func getWebsiteText() -> String? {
        return websiteTextField.text
    }

    func setHasChanges(_ hasChanges: Bool) {
        self.hasChanges = hasChanges
    }

    func getHasChanges() -> Bool {
        return hasChanges
    }
    
    func getAvatarURLString() -> String? {
        return self.avatarURLString
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
