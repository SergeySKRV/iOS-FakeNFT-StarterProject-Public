import UIKit
import ProgressHUD

protocol StatisticsCollectionView: AnyObject, ErrorView {
    func showNFTs()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

final class StatisticsCollectionViewController: UIViewController, StatisticsCollectionView {
    var userProfile: StatisticsProfileModel
    var progressHUD: StatisticsUIBlockingProgressHUD?
    let nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .yaSecondary
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    // MARK: - private properties
    private let presenter = StatisticsCollectionPresenter.shared
    private let navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = UIColor.yaPrimary
        label.text = NSLocalizedString(
            "Statistics.NFTCollection",
            comment: "Коллекция NFT"
        )
        return label
    }()
    // MARK: - public methods
    init(profile: StatisticsProfileModel) {
        self.userProfile = profile
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = UIColor.yaSecondary
        nftCollectionView.register(StatisticsCollectionViewCell.self,
                                   forCellWithReuseIdentifier: "StatisticsCollectionViewCell")
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        view.addSubview(nftCollectionView)
        NSLayoutConstraint.activate(
[
            nftCollectionView.leadingAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: 16
                ),
            nftCollectionView.topAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
            nftCollectionView.heightAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.heightAnchor,
                    constant: -20
                ),
            nftCollectionView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            nftCollectionView.widthAnchor
                .constraint(equalTo: view.widthAnchor, constant: -32)
]
        )
    }
    func showLoadingIndicator() {
        view?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    func hideLoadingIndicator() {
        view?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    func showNFTs() {
        nftCollectionView.reloadData()
    }
    // MARK: - private methods
    private func setupNavigationBar() {
        navigationItem.titleView = navigationBarTitle
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .chevronBackward),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor.yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - extensions
extension StatisticsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statisticsCollectionViewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = nftCollectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell",
                                                               for: indexPath)
                as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.presenter = presenter
        cell.nftCard = presenter.statisticsCollectionViewModel[indexPath.row]
        cell.configureCellData()
        return cell
    }
}

extension StatisticsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (collectionView.bounds.width - 18) / 3,
            height: 192
        )
    }
}
