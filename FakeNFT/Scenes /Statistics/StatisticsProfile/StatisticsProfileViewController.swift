import UIKit
import Kingfisher

final class StatisticsProfileViewController: UIViewController {
    // MARK: - public properties
    var profile: StatisticsProfileModel
    // MARK: - private properties
    private let presenter = StatisticsProfileViewPresenter.shared
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .avatarStub)
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold22
        label.textColor = UIColor.yaPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor.yaPrimary
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let webSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Statistics.moveToSite", comment: "Коллекция NFT"), for: .normal)
        button.titleLabel?.font = Fonts.sfProRegular15
        button.setTitleColor(UIColor.yaPrimary, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.yaPrimary.cgColor
        button.addTarget(self, action: #selector(webButtonTouch), for: .touchUpInside)
        return button
    }()
    private let collectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StatisticsProfileTableViewCell.self,
                           forCellReuseIdentifier: "StatisticsProfileTableViewCell")
        tableView.separatorStyle  = .none
        return tableView
    }()
    // MARK: - public methods
    init(profile: StatisticsProfileModel) {
        self.profile = profile
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        configureView()
    }
    func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .chevronBackward),
            style: .plain,
            target: self,
            action: #selector(backButtonTouch)
        )
        backButton.tintColor = UIColor.yaPrimary
        navigationItem.leftBarButtonItem = backButton
    }
    // MARK: - private methods
    private func configureView() {
        view.backgroundColor = UIColor.yaSecondary
        view.addSubview(avatarImage)
        avatarImage.kf.setImage(with: URL(string: profile.avatarImage), placeholder: UIImage(resource: .avatarStub))
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70)])
        view.addSubview(profileNameLabel)
        profileNameLabel.text = profile.name
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            profileNameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        view.addSubview(descriptionLabel)
        descriptionLabel.text = profile.description
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        view.addSubview(webSiteButton)
        NSLayoutConstraint.activate([
            webSiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            webSiteButton.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            webSiteButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            webSiteButton.heightAnchor.constraint(equalToConstant: 40)])
        view.addSubview(collectionTableView)
        collectionTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionTableView.topAnchor.constraint(equalTo: webSiteButton.bottomAnchor, constant: 41),
            collectionTableView.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            collectionTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32),
            collectionTableView.heightAnchor.constraint(equalToConstant: 54)])
        collectionTableView.delegate = self
        collectionTableView.dataSource = self
    }
    @objc private func webButtonTouch() {
        presenter.showWebView()
    }
    @objc private func backButtonTouch() {
        self.dismiss(animated: true)
    }
}
// MARK: - extensions
extension StatisticsProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticsProfileTableViewCell(style: .default,
                                                  reuseIdentifier: "StatisticsProfileTableViewCell",
                                                  nftCount: profile.nftCount)
        return cell
    }
}
extension StatisticsProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if profile.nftCount>0 {
            presenter.showNFTCollection()
        }
    }
}
