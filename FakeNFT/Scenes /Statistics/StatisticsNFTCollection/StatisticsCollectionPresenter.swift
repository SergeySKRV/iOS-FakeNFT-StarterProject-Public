import UIKit



enum StatisticsCollectionViewState {
    case initial, loading, failed(Error), data
}

final class StatisticsCollectionPresenter {
    // MARK: - public properties:
    static let shared = StatisticsCollectionPresenter()
    weak var view: StatisticsCollectionViewController?
    var userProfile: StatisticsProfileModel?
    var statisticsCollectionViewModel: [StatisticsNFTModel]
    // MARK: - private properties:
    private var state = StatisticsCollectionViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
   
        private let stubNFT1: StatisticsNFTModel = .init(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/1.png",
            name: "Charity",
            price: 21.63,
            rating: 1,
            id: "1",
            isLike: false,
            isInCart: false
        )
        private let stubNFT2: StatisticsNFTModel = .init(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png",
            name: "Aurelio",
            price: 8.08,
            rating: 2,
            id: "2",
            isLike: false,
            isInCart: false
        )
        private let stubNFT3: StatisticsNFTModel = .init(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Mowgli/1.png",
            name: "Murray",
            price: 47.39,
            rating: 2,
            id: "3",
            isLike: false,
            isInCart: false
        )
        private let stubNFT4: StatisticsNFTModel = .init(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Cashew/1.png",
            name: "Barbara",
            price: 26.71,
            rating: 2,
            id: "4",
            isLike: false,
            isInCart: false
        )
        private let stubNFT5: StatisticsNFTModel = .init(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Calder/1.png",
            name: "Edmund",
            price: 1.72,
            rating: 5,
            id: "5",
            isLike: false,
            isInCart: false
        )
        // MARK: - public methods
        func viewDidLoad() {
            state = .loading
            
        }
        // MARK: - private methods:
    private init () {
        statisticsCollectionViewModel = [stubNFT1, stubNFT2, stubNFT3, stubNFT4, stubNFT5]
       
    }
        private func loadNFTCollection() {
            guard let userProfile = view?.userProfile else {return}
            let networkClient = DefaultNetworkClient()
            let service = NftServiceImpl(networkClient: networkClient, storage: NftStorageImpl())
            for nftId in userProfile.nfts {
                service.loadNft(id: nftId) {[weak self] result in
                    switch result {
                    case .success(let nft):
                     guard  let images = nft.images,
                        let name = nft.name,
                        let price = nft.price,
                        let rating = nft.rating,
                        let id = nft.id
                                else { return }
                        let isLike = false
                        let isInCart = false
                        self?.statisticsCollectionViewModel.append(StatisticsNFTModel(image: images[0],
                                                                                name: name,
                                                                                price: Float(price),
                                                                                rating: rating,
                                                                                id: id,
                                                                                isLike: isLike,
                                                                                isInCart: isInCart))
                       print("ura")
                    case .failure(let error):
                        self?.state = .failed(error)
                        print("error in SCVP \(error)")
                    }
                }
            }
            state = .data
    }
        private func stateDidChanged() {
            switch state {
            case .initial:
                assertionFailure("can't move to initial state")
            case .loading:
                view?.showLoadingIndicator()
                loadNFTCollection()
            case .data:
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
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    }
