import UIKit

// MARK: - ProfilePresenter
final class ProfilePresenter: ProfilePresenterProtocol {

    // MARK: - UI Properties
    private weak var view: ProfilePresenterOutput?
    private let userService: UserProfileService
    private let servicesAssembly: ServicesAssembly

    // MARK: - UI Properties
    private var userProfile: UserProfile?
    private var tableData: [ProfileSection] = []

    // MARK: - Lifecycle
    required init(view: ProfilePresenterOutput, userService: UserProfileService, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.userService = userService
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        view?.showLoading()
        setupTableView()
        loadProfileDataFromService()
    }

    func viewWillAppear() {
        refreshProfileData()
    }

    // MARK: - Public Methods
    func openWebsite() {
        guard let websiteURL = userProfile?.website,
              URL(string: websiteURL) != nil else {
            return
        }
        view?.showWebViewController(urlString: websiteURL)
    }

    func editProfileTapped() {
        guard let profile = userProfile else { return }
        view?.showEditProfileViewController(with: profile)
    }

    func refreshProfileData() {
        view?.showLoading()
        loadProfileDataFromService()
    }

    func handleProfileUpdate(_ profile: UserProfile) {
        self.userProfile = profile
        setupTableView()
        DispatchQueue.main.async { [weak self] in
            if let profileViewController = self?.view as? UIViewController,
               let tableView = profileViewController.view.subviews.first(where: { $0 is UITableView }) as? UITableView {
                tableView.reloadData()
            }
        }
        view?.updateProfileUI(profile)
    }

    // MARK: - TableView Methods (ProfilePresenterTableViewOperations)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < tableData.count else { return 0 }
        return tableData[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.defaultReuseIdentifier, for: indexPath) as? ProfileTableViewCell else {
            assertionFailure("Could not dequeue ProfileTableViewCell")
            return UITableViewCell()
        }
        guard indexPath.section < tableData.count else { return cell }
        guard indexPath.row < tableData[indexPath.section].items.count else { return cell }

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
        54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.section < tableData.count else { return }
        guard indexPath.row < tableData[indexPath.section].items.count else { return }

        let item = tableData[indexPath.section].items[indexPath.row]
        switch item.title {
        case NSLocalizedString("EditProfile.myNFT", comment: ""):
            let myNFTController = MyNFTViewController(servicesAssembly: servicesAssembly)

            if let profileViewController = self.view as? UIViewController,
               let navController = profileViewController.navigationController {
                navController.pushViewController(myNFTController, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: myNFTController)
                navController.modalPresentationStyle = .fullScreen
                if let profileViewController = self.view as? UIViewController {
                    profileViewController.present(navController, animated: true)
                }
            }
        case NSLocalizedString("EditProfile.favoritesNFT", comment: ""):
            let favoriteNFTAssembly = FavoriteNFTAssembly(servicesAssembler: servicesAssembly)
            let favoriteNFTViewController = favoriteNFTAssembly.build()

            if let profileViewController = self.view as? UIViewController,
               let navController = profileViewController.navigationController {
                navController.pushViewController(favoriteNFTViewController, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: favoriteNFTViewController)
                navController.modalPresentationStyle = .fullScreen
                if let profileViewController = self.view as? UIViewController {
                    profileViewController.present(navController, animated: true)
                }
            }
        default:
            break
        }
    }

    // MARK: - Private Methods
    private func setupTableView() {
        let myNFTsCount = userProfile?.nfts.count ?? 0
        let favoritesNFTsCount = userProfile?.likes.count ?? 0

        tableData = [
            ProfileSection(title: "", items: [
                ProfileItem(title: NSLocalizedString("EditProfile.myNFT", comment: ""), subtitle: "(\(myNFTsCount))"),
                ProfileItem(title: NSLocalizedString("EditProfile.favoritesNFT", comment: ""), subtitle: "(\(favoritesNFTsCount))")
            ])
        ]
    }

    private func loadProfileDataFromService() {
        userService.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
            }

            switch result {
            case .success(let profile):
                self?.userProfile = profile
                self?.setupTableView()
                DispatchQueue.main.async { [weak self] in
                    if let profileViewController = self?.view as? UIViewController,
                       let tableView = profileViewController.view.subviews.first(where: { $0 is UITableView }) as? UITableView {
                        tableView.reloadData()
                    }
                    self?.view?.updateProfileUI(profile)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.showError(error)
                }
            }
        }
    }
}
