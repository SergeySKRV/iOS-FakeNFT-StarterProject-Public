//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 08.09.2025.
//

import UIKit

// MARK: - MyNFTPresenter
final class MyNFTPresenter: MyNFTPresenterProtocol {

    // MARK: - UI Properties
    private weak var view: MyNFTViewProtocol?
    private let nftService: NftService
    private let userService: UserProfileService
    private let servicesAssembly: ServicesAssembly

    // MARK: - UI Properties
    private var originalNftItems: [NFTItem] = []
    private var sortedNftItems: [NFTItem] = []
    private var currentSortOption: NFTSortOption = .byName

    private(set) var userProfile: UserProfile?

    // MARK: - Lifecycle
    init(view: MyNFTViewProtocol, nftService: NftService, userService: UserProfileService, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.nftService = nftService
        self.userService = userService
        self.servicesAssembly = servicesAssembly
    }

    func viewDidLoad() {
        view?.showLoading()
        loadUserProfileAndNFTs()
    }

    func viewWillAppear() {
    }

    // MARK: - Public Methods
    func sortButtonTapped() {
        view?.showSortOptions(NFTSortOption.allCases, selectedIndex: NFTSortOption.allCases.firstIndex(of: currentSortOption) ?? 0)
    }

    func sortOptionSelected(_ option: NFTSortOption) {
        currentSortOption = option
        sortAndDisplayNFTs()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < sortedNftItems.count else {
            return
        }
        let selectedNFTId = sortedNftItems[indexPath.row].id

        let nftDetailAssembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftDetailInput = NftDetailInput(id: selectedNFTId)
        let nftDetailViewController = nftDetailAssembly.build(with: nftDetailInput)
        view?.showNFTDetails(nftDetailViewController)
    }

    func handleHeartTap(for nftId: String, isSelected: Bool) {
        userService.updateUserLikes(nftId: nftId, isLiked: isSelected) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if var profile = self?.userProfile {
                        if isSelected {
                            profile.likes.insert(nftId)
                        } else {
                            profile.likes.remove(nftId)
                        }
                        self?.userProfile = profile
                    }
                    self?.view?.displayNFTs(self?.sortedNftItems ?? [])
                case .failure(let error):
                    self?.view?.showError(error)
                    self?.view?.displayNFTs(self?.sortedNftItems ?? [])
                }
            }
        }
    }

    // MARK: - Private Methods
    private func loadUserProfileAndNFTs() {
        userService.fetchUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userProfile = profile
                self?.loadNFTs(for: profile.nfts)
            case .failure(let error):
                self?.view?.showError(error)
                self?.view?.hideLoading()
            }
        }
    }

    private func loadNFTs(for userNftIds: [String]) {
        if userNftIds.isEmpty {
            DispatchQueue.main.async {
                self.originalNftItems = []
                self.sortedNftItems = []
                self.view?.displayNFTs([])
                self.view?.hideLoading()
            }
            return
        }

        self.loadNftDetails(for: userNftIds) { [weak self] nftItems in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.originalNftItems = nftItems
                self.sortAndDisplayNFTs()
                self.view?.hideLoading()
            }
        }
    }

    private func loadNftDetails(for ids: [String], completion: @escaping ([NFTItem]) -> Void) {
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var loadingErrors: [Error] = []

        let syncQueue = DispatchQueue(label: "nft.loading.sync")

        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { result in
                defer { group.leave() }
                syncQueue.sync {
                    switch result {
                    case .success(let nft):
                        loadedNfts.append(nft)
                    case .failure(let error):
                        loadingErrors.append(error)
                    }
                }
            }
        }

        group.notify(queue: .global(qos: .userInitiated)) {
            let defaultImageURL = URL(string: "https://example.com/default-nft.jpg")!
            let nftItems: [NFTItem] = loadedNfts.compactMap { nft in
                let formattedAuthor = self.formatAuthor(from: nft.author)
                let imageURL = nft.images.first ?? defaultImageURL

                return NFTItem(
                    id: nft.id,
                    name: nft.name,
                    rating: Double(nft.rating),
                    author: formattedAuthor,
                    price: "\(String(format: "%.2f", nft.price)) ETH",
                    imageUrl: imageURL
                )
            }

            DispatchQueue.main.async {
                completion(nftItems)
            }
        }
    }

    private func sortAndDisplayNFTs() {
        self.sortedNftItems = sortNFTs(originalNftItems, by: currentSortOption)
        view?.displayNFTs(sortedNftItems)
    }

    private func sortNFTs(_ items: [NFTItem], by option: NFTSortOption) -> [NFTItem] {
        switch option {
        case .byPrice:
            return items.sorted { nft1, nft2 in
                let price1 = extractPrice(from: nft1.price)
                let price2 = extractPrice(from: nft2.price)
                return price1 < price2
            }
        case .byRating:
            return items.sorted { $0.rating > $1.rating }
        case .byName:
            return items.sorted { $0.name < $1.name }
        }
    }

    private func extractPrice(from priceString: String) -> Double {
        let cleanString = priceString.replacingOccurrences(of: " ETH", with: "").replacingOccurrences(of: ",", with: ".")
        return Double(cleanString) ?? 0.0
    }

    private func formatAuthor(from authorString: String) -> String {
        if let url = URL(string: authorString),
           url.scheme != nil,
           let host = url.host {

            let hostComponents = host.components(separatedBy: ".")
            if !hostComponents.isEmpty {
                let displayName = hostComponents[0]

                let formattedName = displayName
                    .replacingOccurrences(of: "_", with: " ")
                    .replacingOccurrences(of: "-", with: " ")
                    .split(separator: " ")
                    .map { $0.capitalized }
                    .joined(separator: " ")

                return "от \(formattedName)"
            }
        }

        let formattedName = authorString
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")

        return "от \(formattedName)"
    }
}
