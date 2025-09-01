import UIKit

final class ProfileViewController: UIViewController {
    
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProHeadline3
        label.textColor = UIColor(named: "blackDayNight") ?? .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProCaption2
        label.textColor = UIColor(named: "blackDayNight") ?? .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.sfProCaption1
        label.textColor = UIColor(named: "blueUniversal")
        label.text = "Joaquin Phoenix.com"
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(resource: .edit).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: "blackDayNight") ?? .label
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var userProfile: UserProfile?
    private var tableData: [ProfileSection] = []
    private var myNFTCount = 112
    private var favoritesNFTCount = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProfileData()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupConstraints()
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
    
    private func setupTableView() {
        tableData = [
            ProfileSection(title: "", items: [
                ProfileItem(title: "Мои NFT", subtitle: "(\(myNFTCount))"),
                ProfileItem(title: "Избранные NFT", subtitle: "(\(favoritesNFTCount))")
            ])
        ]
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
        
        profileImageView.image = user.photo
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        websiteLabel.text = user.website
    }
    
    @objc private func openWebsite() {
        let webViewController = WebViewController(urlString: "https://practicum.yandex.ru/ios-developer")
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc private func closeWebViewController() {
        dismiss(animated: true)
    }
    
    @objc private func editProfileTapped() {
        let editController = EditProfileViewController()
       
        if let navController = self.navigationController {
            navController.pushViewController(editController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: editController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
}

// MARK: - TableView DataSource and Delegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        let item = tableData[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = tableData[indexPath.section].items[indexPath.row]
        switch item.title {
        case "Мои NFT":
            print("Переход к Моим NFT")
            // TODO: переход к экрану Мои NFT
        case "Избранные NFT":
            print("Переход к Избранным NFT")
            // TODO: переход к экрану Избранных NFT
        default:
            break
        }
    }
}
