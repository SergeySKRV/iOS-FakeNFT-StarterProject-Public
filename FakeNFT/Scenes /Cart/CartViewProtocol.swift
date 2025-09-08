import Foundation

protocol CartViewProtocol: AnyObject {
    func displayCartItems(_ items: [CartItem])
    func updateTotalPrice()
    func showEmptyState()
}

protocol CartPresenterProtocol {
    func viewDidLoad()
    func payButtonTapped()
    func deleteItem(at index: Int)
}
