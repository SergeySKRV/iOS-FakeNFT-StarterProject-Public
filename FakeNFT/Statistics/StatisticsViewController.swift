import UIKit

protocol StatisticsView: AnyObject, ErrorView {
    func showStatistics()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}


final class StatisticsViewController: UIViewController, StatisticsView {
    internal lazy var activityIndicator = UIActivityIndicatorView()
    private let presenter = StatisticsViewPresenter.shared
    private let sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SortIcon"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(filtersButtonTouch), for: .touchUpInside)
        return button
    }()
    
    private let statisticsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: "StatisticsTableViewCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.systemGray6.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.view = self
        configureView()
        presenter.viewDidLoad()
        showStatistics()
    }
    
    private func configureView() {
        view.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        view.addSubview(statisticsTableView)
        statisticsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statisticsTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 16),
            statisticsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            statisticsTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            statisticsTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        statisticsTableView.dataSource = self
        statisticsTableView.delegate = self
    }
    
    private func showSortingAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let title = NSAttributedString(
            string: NSLocalizedString("sort_title", comment: "сортировка"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.label,
                .paragraphStyle: paragraphStyle
            ]
        )
        alert.setValue(title, forKey: "attributedTitle")
        
        
        
        let byNameTitle =  NSLocalizedString("name_sort_title", comment: "по имени")
        alert.addAction(UIAlertAction(title: byNameTitle, style: .default , handler: { [weak self] _ in
            guard let self else { return }
            self.presenter.currentSortMode = .name
        }))
        
        
        
        let byRatingTitle =  NSLocalizedString("rating_sort_title", comment: "по рейтингу")
        alert.addAction(UIAlertAction(title: byRatingTitle, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.presenter.currentSortMode = .nft
        }))
        
        
        let cancelTitle =  NSLocalizedString("close_title", comment: "закрыть")
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
    func showLoadingIndicator() {
        StatisticsUIBlockingProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        StatisticsUIBlockingProgressHUD.dismiss()
    }
    internal func showStatistics () {
        statisticsTableView.reloadData()
        
    }
    
    @objc func filtersButtonTouch() {
        showSortingAlert()
    }
}



extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.statisticsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsTableViewCell") as? StatisticsTableViewCell else { return UITableViewCell() }
        cell.configureCellData(number: indexPath.item+1,
                               avatarImage: presenter.statisticsViewModel[indexPath.item].avatarImage,
                               nameOfUser: presenter.statisticsViewModel[indexPath.item].name,
                               numberOfNFT: presenter.statisticsViewModel[indexPath.item].nftCount)
        return cell
    }
}

