//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 01.09.2025.
//

import UIKit
import Kingfisher

protocol CollectionViewControllerProtocol: AnyObject {
    func collectionViewData(data: CollectionViewData)
    func reloadNftCollectionView()
    func showLoadIndicator()
    func hideLoadIndicator()
    func showWebView(with url: URL)  // Добавьте этот метод
}
/*
//добавил протокол для вызова вебвью
 protocol CollectionView: AnyObject {
     func displayAuthorDetails(_ detailsViewController: WebViewController)
 }
*/

final class CollectionViewController: UIViewController {
    // MARK: - Public Properties
    private let presenter: CollectionPresenterProtocol
    //private let urlString = "https://practicum.yandex.ru/ios-developer"
    // MARK: - Private Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
   
    private lazy var collectionCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CoverCollection")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private lazy var collectionName: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var collectionAuthor: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var collectionAuthorLink: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .yaBlueUniversal
        label.numberOfLines = .zero
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(collectionAuthorLinkTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private lazy var collectionDescription: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = .zero
        label.sizeToFit()
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backward"), for: .normal)
        //button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.addTarget(self,
                         action: #selector(didTapBackButton),
                         for: .touchUpInside)
        return button
    }()
    
    private let nftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadCollectionData()
        presenter.getNfts()
        setupCollectionViewController()
    }
    
    // MARK: - Initializers
    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc
    func didTapBackButton() {
        dismiss(animated: true)
    }
    // вынести в презентер
    @objc
    func collectionAuthorLinkTapped() {
        /*
        let webViewController = WebViewController(urlString: urlString)
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
         */
        presenter.authorLinkTapped()
    }
    
    // MARK: - Private Methods
    private func setupCollectionViewController() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setupCollectionView()
        setupCollectionViewControllerConstrains()
    }
    
    private func addSubviews() {
        
        view.addSubview(scrollView)
        [
            collectionCoverImage,
            descriptionStackView,
            nftCollectionView,
            backButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        [
            collectionName,
            collectionAuthor,
            collectionAuthorLink,
            collectionDescription
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            descriptionStackView.addSubview($0)
        }
    }
    
    private func setupCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
   
    private func setupCollectionViewControllerConstrains() {
       
        var navigationBarHeight: CGFloat {
            (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? Constants.floatZero) +
            (self.navigationController?.navigationBar.frame.height ?? Constants.floatZero)
        }
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -navigationBarHeight),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionCoverImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionCoverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionCoverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionCoverImage.heightAnchor.constraint(equalToConstant: Constants.collectionCoverImageHeight),
            
            descriptionStackView.topAnchor.constraint(equalTo: collectionCoverImage.bottomAnchor, constant: Constants.descriptionStackViewTopIdent),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionName.topAnchor.constraint(equalTo: descriptionStackView.topAnchor),
            collectionName.leadingAnchor.constraint(equalTo: descriptionStackView.leadingAnchor, constant: Constants.collectionNameLeading),
            collectionName.trailingAnchor.constraint(equalTo: descriptionStackView.trailingAnchor, constant: Constants.collectionNameTrailing),
            
            collectionAuthor.topAnchor.constraint(equalTo: collectionName.bottomAnchor, constant: Constants.collectionAuthorTopIdent),
            collectionAuthor.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            
            collectionAuthorLink.leadingAnchor.constraint(equalTo: collectionAuthor.trailingAnchor, constant: Constants.collectionAuthorLinkLeading),
            collectionAuthorLink.centerYAnchor.constraint(equalTo: collectionAuthor.centerYAnchor),
            
            collectionDescription.topAnchor.constraint(equalTo: collectionAuthor.bottomAnchor, constant: Constants.collectionDescriptionTopIdent),
            collectionDescription.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            collectionDescription.trailingAnchor.constraint(equalTo: collectionName.trailingAnchor),
            collectionDescription.bottomAnchor.constraint(equalTo: descriptionStackView.bottomAnchor),
            
            nftCollectionView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: Constants.nftCollectionViewTopIdent),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.nftCollectionViewLeading),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.nftCollectionViewTrailing),
            nftCollectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
}

// MARK: - CollectionViewControllerProtocol
extension CollectionViewController: CollectionViewControllerProtocol {
    func showWebView(with url: URL) {
    
    }
    
    
    func collectionViewData(data: CollectionViewData) {
        DispatchQueue.main.async {
            self.collectionCoverImage.kf.setImage(with: URL(string: data.coverImage))
            self.collectionName.text = data.collectionName
            self.collectionAuthorLink.text = data.authorName
            self.collectionDescription.text = data.description
        }
    }
    
    func reloadNftCollectionView() {
        nftCollectionView.reloadData()
    }
    
    func showLoadIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cellModel = presenter.getModel(for: indexPath)
        cell.configCollectionCell(nftModel: cellModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSizeWith: CGFloat = 0
        var itemSizeHeight: CGFloat = 0
        itemSizeWith = (collectionView.bounds.width - Constants.eighteen) / Constants.three
        itemSizeHeight = Constants.oneHundredNinetyTwo
        return CGSize(width: itemSizeWith, height: itemSizeHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewminimumLineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewminimumInteritemSpacingForSectionAt
    }
}

// MARK: - CollectionViewCellDelegate
extension CollectionViewController: CollectionViewCellDelegate {
    func likeButtonDidChange(for indexPath: IndexPath, isLiked: Bool) {
        presenter.changeLike(for: indexPath, isLiked: isLiked)
    }
    func cartButtonDidChange(for indexPath: IndexPath) {
        presenter.changeOrder(for: indexPath)
    }
}
/*
// MARK: - NftCollectionView

extension CollectionViewController: CollectionView {

    func displayAuthorDetails(_ detailsViewController: WebViewController) {
        present(detailsViewController, animated: true)
    }
}
*/
