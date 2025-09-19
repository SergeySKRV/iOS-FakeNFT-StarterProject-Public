import Foundation

protocol CartViewProtocol: AnyObject {
    func displayCartItems(_ items: [CartItem])
    func updateTotalPrice()
    func showEmptyState()
    func showError(message: String)
    func navigateToPaymentScreen()
}

protocol CartPresenterProtocol {
    func viewDidLoad()
    func payButtonTapped()
    func deleteItem(at index: Int)
    func sortItems(by option: SortOption)
}
