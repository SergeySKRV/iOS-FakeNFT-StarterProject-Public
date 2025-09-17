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
    // MARK: - public properties
    static let shared = StatisticsViewPresenter()
    weak var view: StatisticsViewController?
    var statisticsViewModel: [StatisticsProfileModel] = []
    var currentSortMode = CurrentSortMode.nft {
        didSet {
            sortViewModel()
        }
    }
    // MARK: private properties
    private let storage = StatisticsUsersStorageImpl.shared
    private var state = StatisticsViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    // MARK: - public methods
    func viewDidLoad() {
        switch UserDefaults.standard.string(forKey: StatisticsConstants.statisticsSortingKey) {
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
    // MARK: - private methods
    private init() {
    }
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadStatistics() // TODO: убрать перед ревью
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
        let service = StatisticsUsersServiceImpl(networkClient: networkClient, storage: storage)
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
        let mockDescription = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        let mockNfts = [
            "1fda6f0c-a615-4a1a-aa9c-a1cbd7cc76ae",
            "77c9aa30-f07a-4bed-886b-dd41051fade2",
            "b3907b86-37c4-4e15-95bc-7f8147a9a660",
            "f380f245-0264-4b42-8e7e-c4486e237504"]
        let mockLikes = [String]()
        statisticsViewModel = [
            StatisticsProfileModel(avatarImage: "https://n1s2.hsmedia.ru/10/07/5b/10075bc9f87787e109c8bd9d93e8d66b/600x400_0x0a330c9a_8308133731545062329.jpeg", description: "Very Long Description",
                                   name: "Maxim Sokolov",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/182.jpg",
                                   description: mockDescription,
                                   name: "Tina Duke",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 1),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/594.jpg",
                                   description: mockDescription,
                                   name: "Jimmie Reilly",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/991.jpg",
                                   description: mockDescription,
                                   name: "Antony Langley",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 2),
            StatisticsProfileModel(avatarImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Brendan_Fraser_October_2022.jpg/1200px-Brendan_Fraser_October_2022.jpg",
                                   description: mockDescription,
                                   name: "Brendan Fraser",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 1),
            StatisticsProfileModel(avatarImage: "https://images.iptv.rt.ru/images/cpt8sk3ir4sqiatbcj90.jpg",
                                   description: mockDescription,
                                   name: "Joaquin Phoenix",
                                   nftCount: mockNfts.count,
                                   nfts: mockNfts,
                                   likes: mockLikes,
                                   rating: 1)]
        state = .data
    }
    private func convertStoreToViewModel(_ store: [StatisticsUser]) -> [StatisticsProfileModel] {
        var result: [StatisticsProfileModel] = []
        guard let users = storage.getUsers() else {return []}
        for user in users {
            guard let name = user.name else { break }
            guard let nfts = user.nfts,
                  let avatar = user.avatar,
                  let rating = user.rating,
                  let description = user.description
            else { continue }
            let vmUser = StatisticsProfileModel(avatarImage: avatar,
                                                description: description,
                                                name: name,
                                                nftCount: nfts.count,
                                                nfts: nfts,
                                                likes: [],
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
