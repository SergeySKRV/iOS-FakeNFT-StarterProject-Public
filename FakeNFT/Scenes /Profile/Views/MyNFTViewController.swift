//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 07.09.2025.
//

import UIKit

// MARK: - MyNFTViewController
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

    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yaSecondary
        view.isHidden = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.text = NSLocalizedString("MyNFT.emptyState", comment: "Сообщение при отсутствии NFT")
        label.textAlignment = .center

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let customButton = UIButton(type: .custom)
        let sortImage = UIImage(resource: .sort).withRenderingMode(.alwaysTemplate)
        customButton.setImage(sortImage, for: .normal)
        customButton.tintColor = .yaPrimary
        customButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        customButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: customButton)
        return barButtonItem
    }()

    // MARK: - Properties
    private var presenter: MyNFTPresenterProtocol!
    private var servicesAssembly: ServicesAssembly!
    private var displayedNFTs: [NFTItem] = []

    // MARK: - Lifecycle
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

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
        view.addSubview(emptyStateView)
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

        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: 343),
            emptyStateView.heightAnchor.constraint(equalToConstant: 22),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupPresenter() {
        guard let servicesAssembly = self.servicesAssembly else {
            assertionFailure("ServicesAssembly is not set")
            return
        }
        let nftService = servicesAssembly.nftService
        let userService = servicesAssembly.userService
        presenter = MyNFTPresenter(
            view: self,
            nftService: nftService,
            userService: userService,
            servicesAssembly: servicesAssembly
        )
    }

    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        if navigationController?.viewControllers.first != self && navigationController?.viewControllers.contains(self) == true {
            navigationController?.popViewController(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc
    private func sortButtonTapped() {
        presenter.sortButtonTapped()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension MyNFTViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedNFTs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTTableViewCell = tableView.dequeueReusableCell()
        let nft = displayedNFTs[indexPath.row]
        let myPresenter = presenter as? MyNFTPresenter
        let isLiked = myPresenter?.userProfile?.likes.contains(nft.id) ?? false

        cell.configure(with: nft, isLiked: isLiked) { [weak self] isSelected in
            self?.presenter.handleHeartTap(for: nft.id, isSelected: isSelected)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < displayedNFTs.count else { return }
        let selectedNFTId = displayedNFTs[indexPath.row].id

        guard let servicesAssembly = self.servicesAssembly else {
            assertionFailure("ServicesAssembly is not set")
            return
        }

        let nftDetailAssembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftDetailInput = NftDetailInput(id: selectedNFTId)
        let nftDetailViewController = nftDetailAssembly.build(with: nftDetailInput)
        showNFTDetails(nftDetailViewController)
    }
}

// MARK: - MyNFTViewProtocol
extension MyNFTViewController: MyNFTViewProtocol {
    func displayNFTs(_ nfts: [NFTItem]) {
        self.displayedNFTs = nfts

        if nfts.isEmpty {
            tableView.isHidden = true
            emptyStateView.isHidden = false
        } else {
            tableView.isHidden = false
            emptyStateView.isHidden = true
            tableView.reloadData()
        }
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

    func showNFTDetails(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func showSortOptions(_ options: [NFTSortOption], selectedIndex: Int) {
        let alertController = UIAlertController(
            title: NSLocalizedString("MyNFT.sortTitle", comment: "Заголовок сортировки"),
            message: nil,
            preferredStyle: .actionSheet
        )

        for (index, option) in options.enumerated() {
            let actionStyle: UIAlertAction.Style = (index == selectedIndex) ? .destructive : .default
            let action = UIAlertAction(title: option.title, style: actionStyle) { [weak self] _ in
                self?.presenter.sortOptionSelected(option)
            }
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("MyNFT.sortCancel", comment: "Отмена сортировки"),
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)

        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sortButton
        }

        present(alertController, animated: true, completion: nil)
    }
}
