//
//  FavoriteNFTPresenterImpl.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

final class FavoriteNFTPresenter: FavoriteNFTPresenterProtocol {

    // MARK: - UI Properties
    private weak var view: FavoriteNFTViewProtocol?
    private let nftService: NftService
    private let userService: UserProfileService
    private let servicesAssembly: ServicesAssembly

    // MARK: - UI Properties
    private var favoriteNftItems: [NFTItem] = []

    // MARK: - Lifecycle
    init(
        view: FavoriteNFTViewProtocol,
        nftService: NftService,
        userService: UserProfileService,
        servicesAssembly: ServicesAssembly
    ) {
        self.view = view
        self.nftService = nftService
        self.userService = userService
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        view?.showLoading()
        loadFavoriteNFTs()
    }

    func viewWillAppear() {
        loadFavoriteNFTs()
    }

    // MARK: - Public Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < favoriteNftItems.count else { return }
        let selectedNFTId = favoriteNftItems[indexPath.item].id

        let nftDetailAssembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftDetailInput = NftDetailInput(id: selectedNFTId)
        let nftDetailViewController = nftDetailAssembly.build(with: nftDetailInput)
        view?.showNFTDetails(nftDetailViewController)
    }

    func handleHeartTap(for nftId: String, isSelected: Bool) {
        userService.updateUserLikes(nftId: nftId, isLiked: isSelected) { [weak self] result in
            switch result {
            case .success:
                self?.loadFavoriteNFTs()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    self?.view?.showError(error)
                    self?.loadFavoriteNFTs()
                }
            }
        }
    }

    // MARK: - Private Methods
    private func loadFavoriteNFTs() {
        userService.fetchUserProfile { [weak self] userProfileResult in
            guard let self = self else { return }
            switch userProfileResult {
            case .success(let userProfile):
                let favoriteNftIds = userProfile.likes
                self.processFavoriteNFTs(favoriteNftIds)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.showError(error)
                }
            }
        }
    }

    private func processFavoriteNFTs(_ favoriteNftIds: [String]) {
        if favoriteNftIds.isEmpty {
            DispatchQueue.main.async {
                self.favoriteNftItems = []
                self.view?.hideLoading()
                self.view?.displayNFTs([])
            }
            return
        }

        let group = DispatchGroup()
        var loadedNFTs: [Nft] = []
        var loadErrors: [Error] = []

        for id in favoriteNftIds {
            group.enter()
            self.nftService.loadNft(id: id) { result in
                defer { group.leave() }
                switch result {
                case .success(let nft):
                    loadedNFTs.append(nft)
                case .failure(let error):
                    loadErrors.append(error)
                }
            }
        }

        group.notify(queue: .main) {
            let defaultImageURL = URL(string: "https://cdn1.ozone.ru/s3/multimedia-8/6089328-8.jpg  ")!
            let nftItems: [NFTItem] = loadedNFTs.map { nft in
                let imageURL = nft.images.first ?? defaultImageURL
                return NFTItem(
                    id: nft.id,
                    name: nft.name,
                    rating: Double(nft.rating),
                    author: self.formatAuthor(from: nft.author),
                    price: "\(String(format: "%.2f", nft.price)) ETH",
                    imageUrl: imageURL
                )
            }
            self.favoriteNftItems = nftItems
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.displayNFTs(self.favoriteNftItems)
            }
        }
    }

    private func formatAuthor(from authorString: String) -> String {
        if let url = URL(string: authorString),
           url.scheme != nil,
           let host = url.host {
            let hostComponents = host.components(separatedBy: ".")
            if !hostComponents.isEmpty {
                return hostComponents[0].capitalized
            }
        }
        return authorString
    }
}
