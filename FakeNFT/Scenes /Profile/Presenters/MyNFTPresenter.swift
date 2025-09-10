//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 08.09.2025.
//

import UIKit

final class MyNFTPresenter: MyNFTPresenterProtocol {
    // MARK: - Properties
    private weak var view: MyNFTViewProtocol?
    private let nftService: NftService
    private var nftItems: [NFTItem] = []
    private let servicesAssembly: ServicesAssembly
    private var currentSortOption: NFTSortOption = .byName

    // MARK: - Initialization
    required init(view: MyNFTViewProtocol, nftService: NftService, servicesAssembly: ServicesAssembly) {
        self.view = view
        self.nftService = nftService
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        view?.showLoading()
        loadNFTs()
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
            guard indexPath.row < nftItems.count else { return }
      
            let selectedNFTId = nftItems[indexPath.row].id
            
            let nftDetailAssembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
            let nftDetailInput = NftDetailInput(id: selectedNFTId)
            
            let nftDetailViewController = nftDetailAssembly.build(with: nftDetailInput)
            
            view?.showNFTDetails(nftDetailViewController)
        }
    
    // MARK: - Private Methods
    private func loadNFTs() {
        let mockNFTs = [
            NFTItem(
                id: "7773e33c-ec15-4230-a102-92426a3a6d5a",
                name: "Lilo",
                rating: 5,
                author: "John Doe",
                price: "1,78 ETH",
                imageUrl: URL(string: "https://example.com/nft1.jpg")!,
                imageId: "lilo"
            ),
            NFTItem(
                id: "mock-id-1",
                name: "Spring",
                rating: 3,
                author: "Jane Smith",
                price: "0,95 ETH",
                imageUrl: URL(string: "https://example.com/nft2.jpg")!,
                imageId: "spring"
            ),
            NFTItem(
                id: "mock-id-2",
                name: "April",
                rating: 4,
                author: "Alice Johnson",
                price: "2,30 ETH",
                imageUrl: URL(string: "https://example.com/nft3.jpg")!,
                imageId: "april"
            )
        ]
      
        self.nftItems = mockNFTs
        self.sortAndDisplayNFTs()
        self.view?.hideLoading()
    }
    
    private func sortAndDisplayNFTs() {
        let sortedItems = sortNFTs(nftItems, by: currentSortOption)
        view?.displayNFTs(sortedItems)
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
}
