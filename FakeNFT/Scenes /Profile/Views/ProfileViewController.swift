import Kingfisher
import ProgressHUD
import UIKit

// MARK: - ProfileViewController
final class ProfileViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(resource: .placeholderAvatar)
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold22
        label.textColor = .yaPrimary
        label.textAlignment = .left
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProRegular13
        label.textColor = .yaPrimary
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .natural
        return label
    }()

    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProRegular15
        label.textColor = .yaBlueUniversal
        label.text = NSLocalizedString("Profile.websiteTap", comment: "")
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        label.addGestureRecognizer(tapGesture)
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(resource: .edit).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .yaPrimary
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .yaSecondary
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    // MARK: - Properties
    var servicesAssembly: ServicesAssembly!
    private var presenter: ProfilePresenterProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPresenter()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .yaSecondary
    }

    private func setupConstraints() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteLabel)
        view.addSubview(editButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),

            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),

            websiteLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            websiteLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.widthAnchor.constraint(equalToConstant: 42),
            editButton.heightAnchor.constraint(equalToConstant: 42),

            tableView.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupPresenter() {
        guard let servicesAssembly = self.servicesAssembly else {
            assertionFailure("ServicesAssembly is not set")
            return
        }
        let userService = servicesAssembly.userService
        presenter = ProfilePresenter(view: self, userService: userService, servicesAssembly: servicesAssembly)
    }

    @objc
    private func openWebsite() {
        presenter.openWebsite()
    }

    @objc
    private func editProfileTapped() {
        presenter.editProfileTapped()
    }

    // MARK: - Loading State Management
    private func showLoadingState() {
        profileImageView.isHidden = true
        nameLabel.isHidden = true
        descriptionLabel.isHidden = true
        websiteLabel.isHidden = true
        editButton.isHidden = true
        tableView.isHidden = true

        ProgressHUD.show()
    }

    private func hideLoadingState() {
        ProgressHUD.dismiss()

        profileImageView.isHidden = false
        nameLabel.isHidden = false
        descriptionLabel.isHidden = false
        websiteLabel.isHidden = false
        editButton.isHidden = false
        tableView.isHidden = false
    }
}

// MARK: - TableView DataSource and Delegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter.tableView(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.tableView(tableView, heightForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - ProfilePresenterView
extension ProfileViewController: ProfilePresenterOutput {
    func updateProfileUI(_ viewModel: UserProfileViewModel) {
        hideLoadingState()

        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        websiteLabel.text = viewModel.website

        if let avatarImage = viewModel.avatarImage {
            profileImageView.image = avatarImage
        } else if let avatarString = viewModel.avatarURL, let avatarURL = URL(string: avatarString) {
            profileImageView.kf.setImage(
                with: avatarURL,
                placeholder: UIImage(resource: .placeholderAvatar),
                options: [
                    .transition(.fade(0.2)),
                    .keepCurrentImageWhileLoading
                ]
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        break
                    case .failure:
                        self?.profileImageView.image = UIImage(resource: .placeholderAvatar)
                    }
                }
            }
        } else {
            profileImageView.image = UIImage(resource: .placeholderAvatar)
        }
    }


    func showWebViewController(urlString: String) {
        let webViewController = WebViewController(urlString: urlString)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    func showEditProfileViewController(with profile: UserProfile) {
        let editController = EditProfileViewController(userProfile: profile)
        editController.servicesAssembly = self.servicesAssembly
        editController.delegate = self
        if let navController = self.navigationController {
            navController.pushViewController(editController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: editController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }

    func showError(_ error: Error) {
        hideLoadingState()

        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: "Error title"),
            message: NSLocalizedString("Error.network", comment: "Network error message"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showLoading() {
        showLoadingState()
    }

    func hideLoading() {
        hideLoadingState()
    }
}

// MARK: - EditProfileViewControllerDelegate
extension ProfileViewController: EditProfileViewControllerDelegate {
    func didUpdateProfile(_ profile: UserProfile) {
        presenter.handleProfileUpdate(profile)
    }
}
