import UIKit

final class StatisticsCollectionViewController: UIViewController {
    // MARK: private properties
    private let presenter = StatisticsCollectionPresenter.shared
    private let navigationBarTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = UIColor.yaPrimary
        label.text = "Коллекция NFT"
        return label
    }()
    private let nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yaSecondary
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    // MARK: public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.backgroundColor = UIColor.yaSecondary
        nftCollectionView.register(StatisticsCollectionViewCell.self,
                                   forCellWithReuseIdentifier: "StatisticsCollectionViewCell")
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        view.addSubview(nftCollectionView)
        NSLayoutConstraint.activate([
            nftCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nftCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -20),
            nftCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }
    // MARK: private methods
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
// MARK: extensions
extension StatisticsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statisticsCollectionViewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = nftCollectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell",
                                                               for: indexPath)
                as? StatisticsCollectionViewCell else {return UICollectionViewCell()}
        cell.configureCellData(nftCart: presenter.statisticsCollectionViewModel[indexPath.row])
        return cell
    }
}

extension StatisticsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 18) / 3, height: 192)
    }
}
