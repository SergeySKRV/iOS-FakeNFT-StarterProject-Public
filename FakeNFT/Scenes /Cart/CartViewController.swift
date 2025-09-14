import UIKit

final class CartViewController: UIViewController {
    
    var presenter: CartPresenterProtocol?
    private var cartItems: [CartItem] = []
    
    private struct CacheKeys {
        static let cartItemsCount = "cachedCartItemsCount"
        static let totalPrice = "cachedTotalPrice"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "filterButton"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        button.tintColor = UIColor(resource: .ypBlack)
        return button
    }()
    
    private lazy var totalView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 12
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular15
        label.textColor = UIColor(resource: .ypBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProBold17
        label.textColor = UIColor(resource: .ypGreen)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.sfProBold17
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textAlignment = .center
        label.font = Fonts.sfProBold17
        label.textColor = UIColor(resource: .ypBlack)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        self.presenter = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    init(presenter: CartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        showCachedData()
        
        presenter?.viewDidLoad()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = filterButton
        
        view.addSubview(tableView)
        view.addSubview(totalView)
        view.addSubview(emptyStateLabel)
        
        totalView.addSubview(nftCountLabel)
        totalView.addSubview(totalPriceLabel)
        totalView.addSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalView.topAnchor, constant: -16),
            
            totalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            totalView.heightAnchor.constraint(equalToConstant: 76),
            
            nftCountLabel.topAnchor.constraint(equalTo: totalView.topAnchor, constant: 16),
            nftCountLabel.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: nftCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalView.leadingAnchor, constant: 16),
            
            payButton.centerYAnchor.constraint(equalTo: totalView.centerYAnchor),
            payButton.trailingAnchor.constraint(equalTo: totalView.trailingAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func showCachedData() {
        let defaults = UserDefaults.standard
        let itemCount = defaults.integer(forKey: CacheKeys.cartItemsCount)
        let totalPrice = defaults.double(forKey: CacheKeys.totalPrice)
        
        if itemCount > 0 {
            nftCountLabel.text = "\(itemCount) NFT"
            totalPriceLabel.text = String(format: "%.2f ETH", totalPrice)
            totalView.isHidden = false
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
        }
    }
    
    private func cacheCartData(count: Int, price: Double) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: CacheKeys.cartItemsCount)
        defaults.set(price, forKey: CacheKeys.totalPrice)
    }
    
    private func clearCache() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: CacheKeys.cartItemsCount)
        defaults.removeObject(forKey: CacheKeys.totalPrice)
    }
    
    @objc private func filterButtonTapped() {
        print("Фильтрация нажата")
    }
    
    @objc private func payButtonTapped() {
        presenter?.payButtonTapped()
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CartCell else { return }
        
        let item = cartItems[index]
        let nftImage = cell.getNFTImage()
        
        showDeletePopup(for: index, nftImageURL: item.image, nftName: item.name)
    }
    
    private func showDeletePopup(for index: Int, nftImageURL: String?, nftName: String?) {
        let popupVC = DeletePopupViewController()
        popupVC.nftImageURL = nftImageURL
        popupVC.nftName = nftName
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        
        popupVC.onDelete = { [weak self] in
            self?.presenter?.deleteItem(at: index)
        }
        
        present(popupVC, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseIdentifier, for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: CartViewProtocol {
    func showEmptyState() {
        tableView.isHidden = true
        totalView.isHidden = true
        emptyStateLabel.isHidden = false
        
        clearCache()
    }
    
    func displayCartItems(_ items: [CartItem]) {
        cartItems = items
        tableView.isHidden = false
        totalView.isHidden = false
        emptyStateLabel.isHidden = true
        tableView.reloadData()
        updateTotalPrice()
        
        let totalPrice = items.reduce(0) { $0 + $1.price }
        cacheCartData(count: items.count, price: totalPrice)
    }
    
    func updateTotalPrice() {
        nftCountLabel.text = "\(cartItems.count) NFT"
        
        let totalPrice = cartItems.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = String(format: "%.2f ETH", totalPrice)
        
        cacheCartData(count: cartItems.count, price: totalPrice)
    }
    
    func navigateToPaymentScreen() {
        let paymentVC = PaymentViewController()
        let paymentPresenter = PaymentPresenter(view: paymentVC, cartService: CartService())
        paymentVC.presenter = paymentPresenter
        
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
