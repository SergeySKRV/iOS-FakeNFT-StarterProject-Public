//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

final class MyNFTViewController: UIViewController {
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .yaSecondary
        tableView.separatorStyle = .none
        tableView.register(MyNFTTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private var presenter: MyNFTPresenterProtocol!
    
    private let mockImages = [
        UIImage(resource: .lilo),
        UIImage(resource: .spring),
        UIImage(resource: .april)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupPresenter()
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .yaSecondary
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        navigationItem.title = NSLocalizedString("MyNFT.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .yaPrimary
        
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupPresenter() {
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
        presenter = MyNFTPresenter(view: self, nftService: servicesAssembly.nftService)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        if navigationController?.viewControllers.first != self && navigationController?.viewControllers.contains(self) == true {
            navigationController?.popViewController(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension MyNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTTableViewCell.defaultReuseIdentifier, for: indexPath) as! MyNFTTableViewCell
        
        let mockNFT = NFTItem(
            id: "mock-id-\(indexPath.row)",
            name: ["Lilo", "Spring", "April"][indexPath.row],
            rating: 3,
            author: "John Doe",
            price: "1,78 ETH",
            imageUrl: URL(string: "https://example.com/nft\(indexPath.row).jpg")!
        )
        cell.configure(with: mockNFT, mockImage: mockImages[indexPath.row % mockImages.count])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {
    func displayNFTs(_ nfts: [NFTItem]) {
        tableView.reloadData()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
