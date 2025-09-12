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
    func authorLinkTapped()  // Добавьте этот метод
}

final class CollectionPresenter: CollectionPresenterProtocol {
    func changeLike(for indexPath: IndexPath, isLiked: Bool) {
       
    }
    
    func changeOrder(for indexPath: IndexPath) {
        
    }
    
    // MARK: - Public Properties
    var nfts: [NFTs] = []
    var collectionNft: NFTCollection?
    var authorURL: String?
    weak var collectionView: CollectionViewControllerProtocol?
    
    // MARK: - Private Properties
    private let catalogService: CatalogServiceProtocol
    private let authorsURL: URL?  // Добавьте свойство для хранения URL
    private weak var view: CollectionViewControllerProtocol?
    // MARK: - Initializers
    init(collectionNft: NFTCollection?, catalogService: CatalogServiceProtocol,
         view: CollectionViewControllerProtocol, authorURLString: String) {
        
        self.collectionNft = collectionNft
        self.catalogService = catalogService
        self.view = view
        self.authorsURL = URL(string: authorURLString)
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
                case .failure(let error):
                    print(error)
                    // TODO: - обработать ошибку алертом
                }
                self.collectionView?.hideLoadIndicator()
            })
        }
    }
    
    func loadCollectionData() {
        self.prepare()
        self.collectionView?.hideLoadIndicator()
        loadAuthor()
    }
    
    func getModel(for indexPath: IndexPath) -> NFTCellModel {
        self.convertToCellModel(nft: nfts[indexPath.row])
    }
    
    func authorLinkTapped() {
            guard let url = authorsURL else { return }
            view?.showWebView(with: url)
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
            isLiked: false,
            isInCart: false,
            price: nft.price
        )
    }
    
    private func loadAuthor() {
        self.authorURL = RequestConstants.stubAuthorUrl
    }
}

