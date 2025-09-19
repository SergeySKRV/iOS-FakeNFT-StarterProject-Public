import UIKit

final class PaymentViewController: UIViewController {
    
    var presenter: PaymentPresenterProtocol?
    private var paymentMethods: [PaymentMethod] = []
    private var selectedMethod: PaymentMethod?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PaymentMethodCell.self, forCellWithReuseIdentifier: PaymentMethodCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .ypLightGrey)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var agreementTextLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor(resource: .ypBlack)
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agreementLinkLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.sfProRegular13
        label.textColor = UIColor(resource: .ypBlue)
        label.text = "Пользовательского соглашения"
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Fonts.sfProBold17
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Выбор способа оплаты"
        
        view.addSubview(bottomBackgroundView)
        
        view.addSubview(collectionView)
        view.addSubview(agreementTextLabel)
        view.addSubview(agreementLinkLabel)
        view.addSubview(payButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: agreementTextLabel.topAnchor, constant: -16),
            
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBackgroundView.topAnchor.constraint(equalTo: agreementTextLabel.topAnchor, constant: -20),
            
            agreementTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            agreementTextLabel.bottomAnchor.constraint(equalTo: agreementLinkLabel.topAnchor, constant: -4),
            
            agreementLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLinkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            agreementLinkLabel.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16),
            
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Выбор способа оплаты"
        
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = UIColor(resource: .ypBlack)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func payButtonTapped() {
        presenter?.payButtonTapped(with: selectedMethod)
    }
    
    @objc private func userAgreementTapped() {
        presenter?.userAgreementTapped()
    }
}

extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCell.reuseIdentifier,
            for: indexPath
        ) as? PaymentMethodCell else {
            return UICollectionViewCell()
        }
        
        let method = paymentMethods[indexPath.item]
        cell.configure(with: method)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 7
        let availableWidth = collectionView.frame.width - padding - spacing
        let width = availableWidth / 2
        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMethod = paymentMethods[indexPath.item]
    }
}

extension PaymentViewController: PaymentViewProtocol {
    func showLoading() {
        view.isUserInteractionEnabled = false
        payButton.isEnabled = false
        payButton.backgroundColor = .gray
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func hideLoading() {
        view.isUserInteractionEnabled = true
        payButton.isEnabled = true
        payButton.backgroundColor = UIColor(resource: .ypBlack)
        
        view.subviews.forEach {
            if let indicator = $0 as? UIActivityIndicatorView {
                indicator.removeFromSuperview()
            }
        }
    }
    
    func showPaymentSuccess(message: String) {
        let alert = UIAlertController(
            title: "Успех!",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
        //пока не сверстал экраны ошибки и успеха для оплаты возвращаю на предыдущий экран, в итерации эпика 3/3 буду реализовывать эти экраны
    }
    
    func setPayButtonEnabled(_ enabled: Bool) {
        payButton.isEnabled = enabled
        payButton.backgroundColor = enabled ? UIColor(resource: .ypBlack) : .gray
    }
    
    func displayPaymentMethods(_ methods: [PaymentMethod]) {
        paymentMethods = methods
        collectionView.reloadData()
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
