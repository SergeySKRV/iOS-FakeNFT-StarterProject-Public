import Foundation

protocol PaymentViewProtocol: AnyObject {
    func displayPaymentMethods(_ methods: [PaymentMethod])
    func showError(message: String, retryHandler: (() -> Void)?)
    func showLoading()
    func hideLoading()
    func showPaymentSuccess(message: String)
    func setPayButtonEnabled(_ enabled: Bool)
    func showWebView(with urlString: String, title: String?)
}

protocol PaymentPresenterProtocol {
    func viewDidLoad()
    func payButtonTapped(with method: PaymentMethod?)
//    func userAgreementTapped()
}
