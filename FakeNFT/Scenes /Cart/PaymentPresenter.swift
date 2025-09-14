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
        let errorMessage = "Оплата через \(currency.name) не удалась"
        view?.showError(message: errorMessage)
    }
    
    private func handlePaymentError(error: Error) {
        let errorMessage: String
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "Нет соединения с интернетом"
            case .timedOut:
                errorMessage = "Таймаут соединения"
            default:
                errorMessage = "Ошибка сети: \(urlError.localizedDescription)"
            }
        } else {
            errorMessage = "Ошибка оплаты: \(error.localizedDescription)"
        }
        
        view?.showError(message: errorMessage)
    }
}
