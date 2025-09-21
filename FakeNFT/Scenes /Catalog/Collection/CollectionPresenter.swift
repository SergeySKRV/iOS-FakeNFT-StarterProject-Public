//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    var nfts: [NFTs] { get }
    var collectionView: CollectionViewControllerProtocol? { get set }
    var authorURL: String? { get }
    func getNfts()
    func loadCollectionData()
    func getModel(for indexPath: IndexPath) -> NFTCellModel
    func changeLike(for indexPath: IndexPath, isLiked: Bool)
    func changeOrder(for indexPath: IndexPath)
    func openWebsite()
}

final class CollectionPresenter: CollectionPresenterProtocol {
    func openWebsite() {
        view?.showWebViewController(urlString: RequestConstants.stubAuthorUrl)
    }
    
    // MARK: - Public Properties
    var nfts: [NFTs] = []
    var collectionNft: NFTCollection?
    var authorURL: String?
    var profile: ProfileResult?
    weak var collectionView: CollectionViewControllerProtocol?
    private weak var view: ProfilePresenterOutput? // webview
    // MARK: - Private Properties
    private let catalogService: CatalogServiceProtocol
    
    // MARK: - Initializers
    init(collectionNft: NFTCollection?, catalogService: CatalogServiceProtocol) {
        self.collectionNft = collectionNft
        self.catalogService = catalogService
    }
    
    // Метод для установки view после инициализации
    func setProfilePresenterOutput(_ output: ProfilePresenterOutput) {
        self.view = output
    }
    
    // MARK: - Public Methods
    func getNfts() {
        guard let collectionNft, !collectionNft.nfts.isEmpty else { return }
        collectionNft.nfts.forEach {
            collectionView?.showLoadIndicator()
            catalogService.getNFTs(id: $0, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    self.collectionView?.reloadNftCollectionView()
                    self.collectionView?.hideLoadIndicator()
                case .failure(let error):
                    let errorModel = makeErrorModel(error)
                    self.collectionView?.hideLoadIndicator()
                    collectionView?.openAlert(
                        title: errorModel.title,
                        message: errorModel.message,
                        alertStyle: .alert,
                        actionTitles: errorModel.actionTitles,
                        actionStyles: [.default, .default],
                        actions: [{ _ in }, { _ in
                            self.getNfts()}]
                    )
                }
                self.collectionView?.hideLoadIndicator()
            })
        }
    }
    
    func loadCollectionData() {
        self.prepare()
        loadAuthor()
        getLikes()
        getOrders()
        self.collectionView?.hideLoadIndicator()
    }
    
    func getModel(for indexPath: IndexPath) -> NFTCellModel {
        self.convertToCellModel(nft: nfts[indexPath.row])
    }
    
    func changeLike(for indexPath: IndexPath, isLiked: Bool) {
        collectionView?.showLoadIndicator()
        catalogService.putProfile(id: nfts[indexPath.row].id, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.collectionView?.reloadNftCollectionView()
                self.collectionView?.hideLoadIndicator()
            case .failure(let error):
                let errorModel = makePutErrorModel(error)
                self.collectionView?.hideLoadIndicator()
                collectionView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default],
                    actions: [{ _ in }]
                )
            }
        })
    }
    
    func changeOrder(for indexPath: IndexPath) {
        collectionView?.showLoadIndicator()
        
        let nftId = nfts[indexPath.row].id
        
        catalogService.putOrders(id: nftId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                // После успешного обновления заказа, обновляем данные
                self.getOrders()
            case .failure(let error):
                let errorModel = self.makePutErrorModel(error)
                self.collectionView?.hideLoadIndicator()
                self.collectionView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default],
                    actions: [{ _ in }]
                )
            }
            self.collectionView?.hideLoadIndicator()
        }
    }
    
    
    // MARK: - Private Methods
    private func prepare() {
        guard let collection = collectionNft else { return }
        let collectionViewData = CollectionViewData(
            coverImage: collection.cover,
            collectionName: collection.name.firstUppercased,
            authorName: convertAuthorName(),
            description: collection.description.firstUppercased
        )
        collectionView?.collectionViewData(data: collectionViewData)
    }
    
    private func convertAuthorName() -> String {
        let name = collectionNft?.author
        let modifed = name?.replacingOccurrences(of: "_", with: " ")
        return modifed?.capitalized ?? ""
    }
    
    private func convertToCellModel(nft: NFTs) -> NFTCellModel {
        return NFTCellModel(
            id: nft.id,
            name: nft.name.components(separatedBy: " ").first ?? "",
            image: nft.images.first,
            rating: nft.rating,
            isLiked: catalogService.likeStatus(nft.id),
            isInCart: catalogService.orderStatus(nft.id),
            price: nft.price
        )
    }
    
    private func loadAuthor() {
        self.authorURL = RequestConstants.stubAuthorUrl
    }
    
    private func getLikes() {
        catalogService.getProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.collectionView?.reloadNftCollectionView()
            case .failure(let error):
                let errorModel = makeErrorModel(error)
                self.collectionView?.hideLoadIndicator()
                collectionView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default, .default],
                    actions: [{ _ in }, { _ in
                        self.getLikes()}]
                )
            }
        })
    }
    
    private func getOrders() {
        catalogService.getOrders(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.collectionView?.reloadNftCollectionView()
            case .failure(let error):
                let errorModel = makeErrorModel(error)
                self.collectionView?.hideLoadIndicator()
                collectionView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default, .default],
                    actions: [{ _ in }, { _ in
                        self.getOrders()}]
                )
            }
        })
    }
    
    private func makeErrorModel(_ error: Error) -> AlertModel {
        let title: String = NSLocalizedString("Error.title", comment: "")
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText: String =  NSLocalizedString("Error.repeat", comment: "")
        let cancelText: String = NSLocalizedString("Error.cancel", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [cancelText,
                           actionText]
        )
    }
    
    private func makePutErrorModel(_ error: Error) -> AlertModel {
        let title: String = NSLocalizedString("Error.title", comment: "")
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        let cancelText: String = NSLocalizedString("Error.cancel", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [cancelText]
        )
    }
}
