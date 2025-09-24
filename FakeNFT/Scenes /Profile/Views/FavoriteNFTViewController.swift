//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 16.09.2025.
//

import UIKit

final class FavoriteNFTViewController: UIViewController {

    // MARK: - Properties
    var presenter: FavoriteNFTPresenterProtocol!
    private var displayedNFTs: [NFTItem] = []

    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoriteNFTCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .yaSecondary
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var emptyStateView: UIView = {
        let label = UILabel()
        label.text = NSLocalizedString("FavoritesNFT.emptyState", comment: "Сообщение при отсутствии избранных NFT")
        label.font = Fonts.sfProBold17
        label.textColor = .yaPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }

        required init?(coder: NSCoder) {
            assertionFailure("init(coder:) has not been implemented")
            return nil
        }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupNavigationBar()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    // MARK: - Private Methods
    private func setupUI() {
        title = NSLocalizedString("FavoritesNFT.title", comment: "Заголовок экрана Избранные NFT")
        view.backgroundColor = .yaSecondary
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateView)
        emptyStateView.isHidden = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
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

    @objc
    private func backButtonTapped() {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self {
                navigationController.popViewController(animated: true)
            } else {
                if navigationController.presentingViewController != nil {
                    self.dismiss(animated: true)
                } else {
                    navigationController.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - FavoriteNFTViewProtocol
extension FavoriteNFTViewController: FavoriteNFTViewProtocol {
    func displayNFTs(_ nfts: [NFTItem]) {
        self.displayedNFTs = nfts
        if nfts.isEmpty {
            collectionView.isHidden = true
            emptyStateView.isHidden = false
        } else {
            collectionView.isHidden = false
            emptyStateView.isHidden = true
            collectionView.reloadData()
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }

    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showNFTDetails(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayedNFTs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FavoriteNFTCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nft = displayedNFTs[indexPath.item]

        cell.configure(with: nft) { [weak self] _ in
            self?.presenter.handleHeartTap(for: nft.id, isSelected: false)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteNFTViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 175, height: 82)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
