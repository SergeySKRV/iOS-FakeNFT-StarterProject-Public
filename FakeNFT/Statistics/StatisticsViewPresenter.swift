import Foundation
import UIKit
import Kingfisher

protocol StatisticsViewresenter {
    func viewDidLoad()
}

enum StatisticsViewState {
    case initial, loading, failed(Error), data
}

enum CurrentSortMode {
    case name, nft
    
}


final class StatisticsViewPresenter {
    static let shared = StatisticsViewPresenter()
    
    
    weak var view: StatisticsView?
    var statisticsViewModel: [StatisticsProfileModel] = []
    private let storage = UsersStorageImpl.shared
    private var state = StatisticsViewState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    var currentSortMode = CurrentSortMode.nft {
        didSet {
            sortViewModel()
        }
    }
    
    
    private init() {
    
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingIndicator()
            loadStatistics()
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
        let result = service.loadUsers() {[weak self] result in
            switch result {
            case .success(let users):
                for user in users {
                    self?.statisticsViewModel = self?.convertStoreToViewModel(users).sorted {$0.nftCount > $1.nftCount} ?? []
                    self?.sortViewModel()
                }
                print("Data!")
                self?.state = .data
            case .failure(let error):
                self?.state = .failed(error)
                print("error in SVP \(error)")
            }
        }
    }
    
    private func convertStoreToViewModel(_ store: [User]) -> [StatisticsProfileModel] {
        var result: [StatisticsProfileModel] = []
        guard let users = storage.getUsers() else {return []}
        for user in users {
            guard let name = user.name else { break }
            guard let nfts = user.nfts?.count else { continue }
            guard let avatar = user.avatar else { continue }
            guard let rating = user.rating else { continue }
            print("Name: \(name), avatar: \(avatar), nfts: \(nfts), rating: \(user.rating)")
            let vmUser = StatisticsProfileModel(avatarImage: avatar,
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
    
    private func sortViewModel () {
        switch currentSortMode {
        case .name: statisticsViewModel.sort { $0.name < $1.name }
        case .nft: statisticsViewModel.sort { $0.rating > $1.rating }
        }
        view?.showStatistics()
    }
}
