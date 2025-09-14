import Foundation

final class PaymentPresenter: PaymentPresenterProtocol {
    weak var view: PaymentViewProtocol?
    private let cartService: CartServiceProtocol
    private var paymentMethods: [PaymentMethod] = []
    
    init(view: PaymentViewProtocol, cartService: CartServiceProtocol) {
        self.view = view
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        loadCurrencies()
    }
    
    func payButtonTapped(with method: PaymentMethod?) {
        guard let method = method else {
            view?.showError(message: "Выберите способ оплаты")
            return
        }
        
        processPayment(with: method.currency)
    }
    
    func userAgreementTapped() {
//        if let url = URL(string: "") {
//            UIApplication.shared.open(url)
//        }
        print("Кнопка соглашения нажата")
    }
    
    private func loadCurrencies() {
        cartService.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    let paymentMethods = PaymentMethod.fromCurrencies(currencies)
                    self?.paymentMethods = paymentMethods
                    self?.view?.displayPaymentMethods(paymentMethods)
                    
                case .failure(let error):
                    self?.view?.showError(message: "Не удалось загрузить способы оплаты")
                }
            }
        }
    }
    
    private func processPayment(with currency: Currency) {
        // Заглушка для обработки оплаты
        print("Оплата через: \(currency.name) (\(currency.title))")
        view?.showError(message: "Оплата через \(currency.name) пока не реализована")
    }
}
