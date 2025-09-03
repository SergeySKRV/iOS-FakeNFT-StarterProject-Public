import UIKit

protocol ProfilePresenterView: AnyObject {
    func updateProfileUI(_ profile: UserProfile)
    func showWebViewController(urlString: String)
    func showEditProfileViewController(with profile: UserProfile)
    func showError(_ error: Error)
}

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func openWebsite()
    func editProfileTapped()
    func refreshProfileData()
    func handleProfileUpdate(_ profile: UserProfile)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    private weak var view: ProfilePresenterView?
    private let userService: UserProfileService
    private var userProfile: UserProfile?
    private var tableData: [ProfileSection] = []
    private var myNFTCount = 112
    private var favoritesNFTCount = 11
    
    // MARK: - Initialization
    init(view: ProfilePresenterView, userService: UserProfileService) {
        self.view = view
        self.userService = userService
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        setupTableView()
        loadProfileDataFromService()
    }
    
    func viewWillAppear() {
        refreshProfileData()
    }
    
    func openWebsite() {
        view?.showWebViewController(urlString: "https://practicum.yandex.ru/ios-developer")
    }
    
    func editProfileTapped() {
        guard let profile = userProfile else { return }
        view?.showEditProfileViewController(with: profile)
    }
    
    func refreshProfileData() {
        loadProfileDataFromService()
    }
    
    func handleProfileUpdate(_ profile: UserProfile) {
        self.userProfile = profile
        view?.updateProfileUI(profile)
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        let item = tableData[indexPath.section].items[indexPath.row]
        let localizedItem = ProfileItem(
            title: item.title == "Мои NFT" ? NSLocalizedString("EditProfile.myNFT", comment: "") :
                item.title == "Избранные NFT" ? NSLocalizedString("EditProfile.favoritesNFT", comment: "") :
                item.title,
            subtitle: item.subtitle
        )
        cell.configure(with: localizedItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = tableData[indexPath.section].items[indexPath.row]
        switch item.title {
        case NSLocalizedString("EditProfile.myNFT", comment: ""):
            print("Переход к Моим NFT")
            // TODO: переход к экрану Мои NFT
        case NSLocalizedString("EditProfile.favoritesNFT", comment: ""):
            print("Переход к Избранным NFT")
            // TODO: переход к экрану Избранных NFT
        default:
            break
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableData = [
            ProfileSection(title: "", items: [
                ProfileItem(title: NSLocalizedString("EditProfile.myNFT", comment: ""), subtitle: "(\(myNFTCount))"),
                ProfileItem(title: NSLocalizedString("EditProfile.favoritesNFT", comment: ""), subtitle: "(\(favoritesNFTCount))")
            ])
        ]
    }
    
    private func loadProfileDataFromService() {
        userService.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                self?.view?.updateProfileUI(profile)
            case .failure(let error):
                print("Ошибка получения профиля: \(error)")
                self?.view?.showError(error)
            }
        }
    }
    
    private func loadProfileData() {
        let user = UserProfile(
            photo: UIImage(named: "joaquin") ?? UIImage(resource: .userPic),
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            website: "Joaquin Phoenix.com"
        )
        
        userProfile = user
        view?.updateProfileUI(user)
    }
}
