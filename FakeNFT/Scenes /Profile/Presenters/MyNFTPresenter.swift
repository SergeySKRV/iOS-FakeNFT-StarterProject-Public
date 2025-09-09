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
    private let exampleNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"

    // MARK: - Initialization
    required init(view: MyNFTViewProtocol, nftService: NftService) {
        self.view = view
        self.nftService = nftService
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        view?.showLoading()
        loadNFTs()
    }
    
    // MARK: - Public Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбран NFT с индексом: \(indexPath.row)")
        // TODO: Реализовать переход к деталям NFT или другую логику
    }
    
    // MARK: - Private Methods
    private func loadNFTs() {
        nftService.loadNft(id: exampleNftId) { [weak self] (result: Result<Nft, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let nft):
                let nftItem = NFTItem(
                    id: nft.id,
                    name: "Lilo",
                    rating: 3,
                    author: "John Doe",
                    price: "1,78 ETH",
                    imageUrl: nft.images.first ?? URL(string: "https://example.com/default-image.jpg")!
                )
                self.view?.displayNFTs([nftItem])
            case .failure(let error):
                print("Ошибка загрузки NFT: \(error)")
                self.view?.showError(error)
            }
            self.view?.hideLoading()
        }
    }
}
