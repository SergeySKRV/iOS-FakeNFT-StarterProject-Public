//
//  CatalogVC.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 30.08.2025.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadCatalogTableView()
    func showLoadIndicator()
    func hideLoadIndicator()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    
    private let presenter: CatalogPresenterProtocol
    
     // MARK: - Initializers
     init(presenter: CatalogPresenterProtocol) {
         self.presenter = presenter
         super.init(nibName: nil, bundle: nil)
         self.presenter.catalogView = self
     }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemBackground
        button.addTarget(self,
                         action: #selector(sortButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var catalogTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.allowsMultipleSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getNftCollections()
        setupUI()
    }
    
    func showLoadIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    // MARK: - Action
    @objc
    private func sortButtonTapped() {
        
        let sortTypeModel = presenter.makeSortTypeModel()
        
        let actionSheet = UIAlertController(
            title: sortTypeModel.title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(
            title: sortTypeModel.uPdown,
            style: .default) { _ in
                self.presenter.sortByName()
            })
        
        actionSheet.addAction(UIAlertAction(
            title: sortTypeModel.byName,
            style: .default) { _ in
                self.presenter.sortByName()
            })
        
        actionSheet.addAction(UIAlertAction(
            title: sortTypeModel.byNftCount,
            style: .default) { _ in
                self.presenter.sortByNftCount()
            })
        
        actionSheet.addAction(
            UIAlertAction(
                title: sortTypeModel.close,
                style: .cancel)
        )
        
        present(actionSheet, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(catalogTableView)
        view.addSubview(sortButton)
        setupTableView()
        setupCatalogViewControllerConstrains()
    }
    
    private func setupTableView() {
        catalogTableView.dataSource = self
        catalogTableView.delegate = self
        catalogTableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
    }
    
    private func setupCatalogViewControllerConstrains() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            
            catalogTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            catalogTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    
        ])
    }
    
    private func showNFTCollection(indexPath: IndexPath) {
        let configuration = CatalogSceneConfiguration()
        let collection = presenter.collectionsNft[indexPath.row]
        let viewController = configuration.assemblyCollection(collection)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
}

// MARK: - CatalogViewController
extension CatalogViewController {
    func reloadCatalogTableView() {
        catalogTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.collectionsNft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier, for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        configCell(for: cell, with: indexPath)
        
        return cell
    }
}

extension CatalogViewController {
    func configCell(for cell: CatalogTableViewCell, with indexPath: IndexPath) {
        let collection = presenter.collectionsNft[indexPath.row]
        guard let collectionCover = URL(string: collection.cover) else { return }
        
        cell.setCatalogImage(with: collectionCover)
        cell.setCatalogLabel(with: collection.name, quantity: collection.nfts.count)
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showNFTCollection(indexPath: indexPath)
    }
}

