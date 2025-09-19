//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 31.08.2025.
//

import UIKit

protocol CatalogPresenterProtocol: AnyObject {
    var collectionsNft: [NFTCollection] { get }
    var catalogView: CatalogViewControllerProtocol? { get set }
    func getNftCollections()
    func sortByName()
    func sortByNftCount()
    func makeSortTypeModel() -> SortTypeModel
}

final class CatalogPresenter: CatalogPresenterProtocol {
    // MARK: - Public Properties
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    
    // MARK: - Private Properties
    private let catalogService: CatalogServiceProtocol
    private let sortStorage: SortStorageProtocol

    
    // MARK: - Initializers
    init(catalogService: CatalogServiceProtocol, sortStorage: SortStorageProtocol) {
        self.catalogService = catalogService
        self.sortStorage = sortStorage
    }
    
    // MARK: - Public Methods
    func getNftCollections() {
        catalogView?.showLoadIndicator()
        catalogService.getNftCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.sotrCollections()
                self.catalogView?.reloadCatalogTableView()
            case .failure(let error):
                // TODO: алерт ошибки
                ///
                print("[DEBUG]: [ERROR]: CatalogPresenter: getNftCollections")
                ///
            }
            self.catalogView?.hideLoadIndicator()
        }
    }
    
    func sortByName() {
        sortStorage.saveSort(.byName)
        collectionsNft = collectionsNft.sorted {
            $0.name < $1.name
        }
        catalogView?.reloadCatalogTableView()
    }
    
    func sortByNftCount() {
        sortStorage.saveSort(.byNftCount)
        collectionsNft = collectionsNft.sorted {
            $0.nfts.count < $1.nfts.count
        }
        catalogView?.reloadCatalogTableView()
    }
    
    func makeSortTypeModel() -> SortTypeModel {
        let sortTypeModel = SortTypeModel(
            title: "Сортировка",
            uPdown: "Asc/Desc",
            byName: "По названию",
            byNftCount: "По количеству NFT",
            close: "Закрыть"
        )
        return sortTypeModel
    }
    
    // MARK: - Private Methods
    private func sotrCollections() {
        let sortStorage = sortStorage.getSort()
        switch sortStorage {
        case .byName:
            sortByName()
        case .byNftCount:
            sortByNftCount()
        default: break
        }
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
