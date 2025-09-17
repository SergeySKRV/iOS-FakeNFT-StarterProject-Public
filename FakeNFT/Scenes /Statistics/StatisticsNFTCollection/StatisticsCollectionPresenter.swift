import UIKit

enum StatisticsCollectionViewState {
    case initial, loading
    case failed(Error)
    case data
}

final class StatisticsCollectionPresenter {
    // MARK: - public properties:
    static let shared = StatisticsCollectionPresenter()
    weak var view: StatisticsCollectionViewController?
    var userProfile: StatisticsProfileModel?
    var statisticsCollectionViewModel: [StatisticsNFTModel]
    var likes: [String]?
    var orders: [String]?
    // MARK: - private properties:
    private var state = StatisticsCollectionViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    // MARK: - public methods
    func viewDidLoad() {
        state = .loading
        statisticsCollectionViewModel = []
        orders = []
    }
    func likeButtonTouch() {
    }
    func cartButtonTouch() {
    }
    // MARK: - private methods:
    private init() {
        statisticsCollectionViewModel = []
    }
    private func loadNFTCollection() {
        guard let userProfile = view?.userProfile else { return }
        let networkClient = DefaultNetworkClient()
        let service = StatisticsUsersServiceImpl(
            networkClient: networkClient,
            storage: storage
        )
        let profile = service.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                print("Likes: \(profile.likes)")

                self?.likes = profile.likes
            case .failure(let error):

                print("error in SVP \(error)")
            }
        }

        let nftService = NftServiceImpl(
            networkClient: networkClient,
            storage: NftStorageImpl()
        )
        for nftId in userProfile.nfts {
            nftService.loadNft(id: nftId) { [weak self] result in
                switch result {
                case .success(let nft):
                    guard let images = nft.images,
                        let name = nft.name,
                        let price = nft.price,
                        let rating = nft.rating,
                        let id = nft.id
                    else { return }
                    let isLike = false
                    let isInCart = false
                    if self?.statisticsCollectionViewModel.contains(where: {
                        $0.id == id
                    }) == false {
                        self?.statisticsCollectionViewModel.append(
                            StatisticsNFTModel(
                                image: images[0],
                                name: name,
                                price: Float(price),
                                rating: rating,
                                id: id,
                                isLike: isLike,
                                isInCart: isInCart
                            )
                        )
                    }
                case .failure(let error):
                    self?.state = .failed(error)
                    print("error in SCVP \(error)")
                }
                if (userProfile.nfts.count <= self?
                    .statisticsCollectionViewModel.count ?? 0)
                    && (self?.likes != nil)
                {
                    self?.state = .data
                }
            }
        }

    }
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadNFTCollection()
        case .data:
            for number in 0..<statisticsCollectionViewModel.count - 1 {
                statisticsCollectionViewModel[number].isLike =
                    likes?.contains(where: {
                        $0 == statisticsCollectionViewModel[number].id
                    }) ?? false
            }
            view?.hideLoadingIndicator()
            view?.showNFTs()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoadingIndicator()
            view?.showError(errorModel)
        }
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
        return ErrorModel(message: message, actionText: actionText) {
            [weak self] in
            self?.state = .loading
        }
    }
    private let storage = StatisticsUsersStorageImpl.shared
}
