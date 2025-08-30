import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var websiteLabel: UILabel!
    private var editButton: UIButton!
    private var tableView: UITableView!
    
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
        
        createProfileImageView()
        createNameLabel()
        createDescriptionLabel()
        createWebsiteLabel()
        createEditButton()
        createTableView()
        
        setupConstraints()
    }
    
    private func createProfileImageView() {
        profileImageView = UIImageView(image: UIImage(resource: .userPic))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.systemGray.cgColor
        
        view.addSubview(profileImageView)
    }
    
    private func createNameLabel() {
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.sfProHeadline3
        nameLabel.textColor = UIColor(named: "blackDayNight") ?? .label
        nameLabel.textAlignment = .left
        
        view.addSubview(nameLabel)
    }
    
    private func createDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.sfProCaption2
        descriptionLabel.textColor = UIColor(named: "blackDayNight") ?? .label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .natural
        
        view.addSubview(descriptionLabel)
    }
    
    private func createWebsiteLabel() {
        websiteLabel = UILabel()
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.font = UIFont.sfProCaption1
        websiteLabel.textColor = UIColor(named: "blueUniversal")
        websiteLabel.text = "Joaquin Phoenix.com"
        websiteLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        websiteLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(websiteLabel)
    }
    
    private func createEditButton() {
        editButton = UIButton(type: .custom)
        
        let image = UIImage(resource: .edit).withRenderingMode(.alwaysTemplate)
        editButton.setImage(image, for: .normal)
        editButton.tintColor = UIColor(named: "blackDayNight") ?? .label
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(editButton)
    }
    
    private func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableData = [
            ProfileSection(title: "", items: [
                ProfileItem(title: "Мои NFT", subtitle: "(\(myNFTCount))"),
                ProfileItem(title: "Избранные NFT", subtitle: "(\(favoritesNFTCount))")
            ])
        ]
    }
    
    private func setupConstraints() {
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
        print("Редактирование профиля")
        // TODO: переход к экрану редактирования
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
