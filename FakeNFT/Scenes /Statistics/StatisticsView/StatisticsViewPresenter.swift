import UIKit
import Kingfisher

protocol StatisticsViewPresenterProtocol {
    func viewDidLoad()
}

enum StatisticsViewState {
    case initial, loading, failed(Error), data
}

enum CurrentSortMode {
    case name, nft
}

final class StatisticsViewPresenter {
    // MARK: public properties
    static let shared = StatisticsViewPresenter()
    weak var view: StatisticsViewController?
    var statisticsViewModel: [StatisticsProfileModel] = []
    var currentSortMode = CurrentSortMode.nft {
        didSet {
            sortViewModel()
        }
    }
    // MARK: private properties
    private let storage = UsersStorageImpl.shared
    private var state = StatisticsViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    // MARK: public methods
    func viewDidLoad() {
        switch UserDefaults.standard.string(forKey: Constants.statisticsSortingKey) {
        case "name": currentSortMode = .name
        case "rating": currentSortMode = .nft
        default: currentSortMode = .nft
        }
        state = .loading
    }
    func showProfile(indexPath: IndexPath) {
        let profileViewController = StatisticsProfileViewController(profile: statisticsViewModel[indexPath.row])
        let navController = UINavigationController(rootViewController: profileViewController)
        navController.modalPresentationStyle = .fullScreen
        view?.present(navController, animated: true)
    }
    // MARK: private methods
    private init() {
    }
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadStatistics()
            // loadMockStatistics() // Для ускорения отладки работаем с моковыми данными
        case .data:
            view?.hideLoadingIndicator()
            view?.showStatistics()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoadingIndicator()
            view?.showError(errorModel)
        }
    }
    private func loadStatistics() {
        let networkClient = DefaultNetworkClient()
        let service = UsersServiceImpl(networkClient: networkClient, storage: storage)
        let _: () = service.loadUsers {[weak self] result in
            switch result {
            case .success(let users):
                for _ in users {
                    self?.statisticsViewModel = self?.convertStoreToViewModel(users).sorted {
                        $0.nftCount > $1.nftCount} ?? []
                    self?.sortViewModel()
                }
                self?.state = .data
            case .failure(let error):
                self?.state = .failed(error)
                print("error in SVP \(error)")
            }
        }
    }
    private func loadMockStatistics() {
        let mockDesription = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        statisticsViewModel = [
            StatisticsProfileModel(avatarImage: "https://n1s2.hsmedia.ru/10/07/5b/10075bc9f87787e109c8bd9d93e8d66b/600x400_0x0a330c9a_8308133731545062329.jpeg", description: "Very Long Description",
                                   name: "Maxim Sokolov",
                                   nftCount: 0,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/182.jpg",
                                   description: mockDesription,
                                   name: "Tina Duke",
                                   nftCount: 0,
                                   rating: 1),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/594.jpg",
                                   description: mockDesription,
                                   name: "Jimmie Reilly",
                                   nftCount: 0,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/991.jpg",
                                   description: mockDesription,
                                   name: "Antony Langley",
                                   nftCount: 0,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Brendan_Fraser_October_2022.jpg/1200px-Brendan_Fraser_October_2022.jpg",
                                   description: mockDesription,
                                   name: "Brendan Fraser",
                                   nftCount: 21,
                                   rating: 1),
            StatisticsProfileModel(avatarImage: "https://images.iptv.rt.ru/images/cpt8sk3ir4sqiatbcj90.jpg",
                                   description: mockDesription,
                                   name: "Joaquin Phoenix",
                                   nftCount: 11,
                                   rating: 1)]
        state = .data
    }
    private func convertStoreToViewModel(_ store: [User]) -> [StatisticsProfileModel] {
        var result: [StatisticsProfileModel] = []
        guard let users = storage.getUsers() else {return []}
        for user in users {
            guard let name = user.name else { break }
            guard let nfts = user.nfts?.count else { continue }
            guard let avatar = user.avatar else { continue }
            guard let rating = user.rating else { continue }
            guard let description = user.description else { continue }
            let vmUser = StatisticsProfileModel(avatarImage: avatar,
                                                description: description,
                                                name: name,
                                                nftCount: nfts,
                                                rating: Int(rating) ?? 0)
            result.append(vmUser)
        }
        return result
    }
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    private func sortViewModel() {
        switch currentSortMode {
        case .name: statisticsViewModel.sort { $0.name < $1.name }
        case .nft: statisticsViewModel.sort { $0.rating > $1.rating }
        }
        view?.showStatistics()
    }
}
