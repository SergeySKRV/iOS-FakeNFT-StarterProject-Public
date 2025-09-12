import UIKit

final class StatisticsProfileViewController: UIViewController {
    
    private let presenter = StatisticsProfileViewPresenter.shared
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor.yaPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTouch), for: .touchUpInside)
        return button
    }()
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .avatarStub)
        return imageView
    }()
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold22
        label.textColor = UIColor.yaPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joaquin Phoeninx"
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor.yaPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дизайнер из Казани, люблю цифровое искусство \n и бейглы. В моей коллекции уже 100+ NFT,\n и еще больше — на моём сайте. Открыт \n к коллаборациям."
        return label
    }()
    private let webSiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт пользователя", for: .normal)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        configureView()
    }
    private func configureView() {
        view.backgroundColor = UIColor.yaSecondary
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        view.addSubview(avatarImage)
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70)])
        view.addSubview(profileNameLabel)
        NSLayoutConstraint.activate([
            profileNameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 16),
            profileNameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            profileNameLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        view.addSubview(descriptionLabel)
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

extension StatisticsProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatisticsProfileTableViewCell(style: .default,
                                                  reuseIdentifier: "StatisticsProfileTableViewCell",
                                                  titleString: "Коллекция NFT (112)")
       return cell
    }
}
extension StatisticsProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}
