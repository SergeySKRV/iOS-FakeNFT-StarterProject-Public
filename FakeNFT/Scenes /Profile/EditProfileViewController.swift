import UIKit
import ProgressHUD

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .userPic)
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        let cameraImage = UIImage(resource: .cameraPic).withRenderingMode(.alwaysTemplate)
        button.setImage(cameraImage, for: .normal)
        button.tintColor = UIColor(named: "blackDayNight")
        button.backgroundColor = UIColor(named: "lightGreyDayNight")
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProHeadline3
        label.textColor = UIColor(named: "blackDayNight")
        label.text = "Имя"
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "lightGreyDayNight") ?? .systemGray
        textField.layer.cornerRadius = 12
        textField.placeholder = "Joaquin Phoenix"
        textField.text = "Joaquin Phoenix"
        textField.font = UIFont.sfProBodyRegular
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProHeadline3
        label.textColor = UIColor(named: "blackDayNight") ?? .label
        label.text = "Описание"
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(named: "lightGreyDayNight") ?? .systemGray
        textView.layer.cornerRadius = 12
        textView.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        textView.font = UIFont.sfProBodyRegular
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        return textView
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProHeadline3
        label.textColor = UIColor(named: "blackDayNight") ?? .label
        label.text = "Сайт"
        return label
    }()
    
    private lazy var websiteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "lightGreyDayNight") ?? .systemGray
        textField.layer.cornerRadius = 12
        textField.placeholder = "Joaquin Phoenix.com"
        textField.text = "Joaquin Phoenix.com"
        textField.font = UIFont.sfProBodyRegular
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.sfProBodyBold
        button.setTitleColor(UIColor(named: "whiteDayNight"), for: .normal)
        button.backgroundColor = UIColor(named: "blackDayNight")
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var userProfile: UserProfile?
    private var hasChanges = false // Флаг для отслеживания изменений
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProfileData()
        setupNavigationBar()
        
        // Устанавливаем наблюдатели за изменениями в текстовых полях
        observeTextFieldsForChanges()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor(named: "blackDayNight") ?? .label
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupConstraints()
    }
    
    private func loadProfileData() {
        let user = UserProfile(
            photo: UIImage(named: "joaquin") ?? UIImage(resource: .userPic),
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "Joaquin Phoenix.com"
        )
        
        userProfile = user
        updateUI()
    }
    
    private func updateUI() {
        guard let user = userProfile else { return }
        
        nameTextField.text = user.name
        descriptionTextView.text = user.description
        websiteTextField.text = user.website
    }
    
    private func observeTextFieldsForChanges() {
        // Наблюдаем за изменениями в текстовых полях
        nameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        websiteTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        
        // Для UITextView используем делегат
        descriptionTextView.delegate = self
    }
    
    @objc private func handleTextFieldChange() {
        hasChanges = true
    }
    
    @objc private func handleTextViewChange() {
        hasChanges = true
    }
    
    @objc private func backButtonTapped() {
        if hasChanges {
            showExitConfirmationAlert()
        } else {
            dismiss(animated: true)
        }
    }
    
    private func showExitConfirmationAlert() {
        let alertController = UIAlertController(
            title: "Уверены,\nчто хотите выйти?",
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(
            title: "Остаться",
            style: .cancel,
            handler: nil
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Выйти",
            style: .default,
            handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }
        ))
        
        present(alertController, animated: true)
    }

    @objc private func saveButtonTapped() {
        showLoader()
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.hideLoader()
            self.dismiss(animated: true)
        }
    }
    
    @objc private func cameraButtonTapped() {
        showPhotoOptionsAlert()
    }
    
    private func showPhotoOptionsAlert() {
        let alertController = UIAlertController(
            title: "Фото профиля",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(
            title: "Изменить фото",
            style: .default,
            handler: { [weak self] _ in
                self?.showPhotoURLAlert()
            }
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Удалить фото",
            style: .destructive,
            handler: { [weak self] _ in
                self?.profileImageView.image = UIImage(resource: .userPic)
            }
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: nil
        ))
        
        present(alertController, animated: true)
    }
    
    private func showPhotoURLAlert() {
        let alertController = UIAlertController(
            title: "Ссылка на фото",
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "https://example.com/photo.jpg"
            textField.text = "http://www.example.com"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        
        alertController.addAction(UIAlertAction(
            title: "Отмена",
            style: .cancel,
            handler: nil
        ))
        
        alertController.addAction(UIAlertAction(
            title: "Сохранить",
            style: .default,
            handler: { [weak self] _ in
                if let textField = alertController.textFields?.first {
                    if URL(string: textField.text ?? "") != nil {
                        self?.profileImageView.image = UIImage(resource: .userPic)
                    }
                }
            }
        ))
        
        present(alertController, animated: true)
    }
    
    private func showLoader() {
       ProgressHUD.show()
    }
    
    private func hideLoader() {
        ProgressHUD.dismiss()
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
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        hasChanges = true
    }
}
