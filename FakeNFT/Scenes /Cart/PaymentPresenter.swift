import Foundation

final class PaymentPresenter: PaymentPresenterProtocol {
    weak var view: PaymentViewProtocol?
    private let cartService: CartServiceProtocol
    private var paymentMethods: [PaymentMethod] = []
    private var currentPaymentMethod: Currency?
    
    init(view: PaymentViewProtocol, cartService: CartServiceProtocol) {
        self.view = view
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        loadCurrencies()
    }
    
    func payButtonTapped(with method: PaymentMethod?) {
        guard let method = method else {
            view?.showError(message: "Выберите способ оплаты", retryHandler: nil)
            return
        }
        
        currentPaymentMethod = method.currency
        processPayment(with: method.currency)
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
                    self?.view?.showError(message: "Не удалось загрузить способы оплаты", retryHandler: nil)
                }
            }
        }
    }
    
    private func processPayment(with currency: Currency) {
        view?.showLoading()
        view?.setPayButtonEnabled(false)
        
        cartService.proceedToPayment(currencyId: currency.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                self?.view?.setPayButtonEnabled(true)
                
                switch result {
                case .success(let paymentResponse):
                    if paymentResponse.success {
                        self?.handlePaymentSuccess(currency: currency, response: paymentResponse)
                    } else {
                        self?.handlePaymentFailure(currency: currency)
                    }
                    
                case .failure(let error):
                    self?.handlePaymentError(error: error)
                }
            }
        }
    }
    
    private func handlePaymentSuccess(currency: Currency, response: PaymentResponse) {
        let successMessage = "Оплата через \(currency.name) прошла успешно!"
        view?.showPaymentSuccess(message: successMessage)
    }
    
    private func handlePaymentFailure(currency: Currency) {
        let errorMessage = "Не удалось произвести оплату"
        view?.showError(message: errorMessage, retryHandler: { [weak self] in
            self?.retryPayment()
        })
    }
    
    private func handlePaymentError(error: Error) {
        let errorMessage = "Не удалось произвести оплату"
        view?.showError(message: errorMessage, retryHandler: { [weak self] in
            self?.retryPayment()
        })
    }
    
    private func retryPayment() {
        guard let currency = currentPaymentMethod else { return }
        processPayment(with: currency)
    }
}
