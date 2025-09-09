import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Properties
    private weak var view: ProfilePresenterOutput?
    private let userService: UserProfileService
    private var userProfile: UserProfile?
    private var tableData: [ProfileSection] = []
    private var myNFTCount = 112
    private var favoritesNFTCount = 11
    
    // MARK: - Initialization
    required init(view: ProfilePresenterOutput, userService: UserProfileService) {
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
        return 54
    }
    
    // MARK: - TableView Methods (обновленный didSelectRowAt)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = tableData[indexPath.section].items[indexPath.row]
        switch item.title {
        case NSLocalizedString("EditProfile.myNFT", comment: ""):
            let myNFTController = MyNFTViewController()
            if let profileViewController = self.view as? UIViewController,
               let navController = profileViewController.navigationController {
                navController.pushViewController(myNFTController, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: myNFTController)
                navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                if let profileViewController = self.view as? UIViewController {
                    profileViewController.present(navController, animated: true)
                }
            }
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
