import Foundation

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    private let cartService: CartServiceProtocol
    
    private var cartItems: [CartItem] = []
    
    init(view: CartViewProtocol, cartService: CartServiceProtocol) {
        self.view = view
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        loadCartItems()
    }
    
    func payButtonTapped() {
        print("Кнопка оплаты нажата (заглушка)")
    }
    
    func deleteItem(at index: Int) {
        guard index < cartItems.count else { return }
        let itemId = cartItems[index].id
        
        cartService.deleteItemFromCart(itemId: itemId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.cartItems.remove(at: index)
                    self?.view?.displayCartItems(self?.cartItems ?? [])
                    self?.view?.updateTotalPrice()
                case .failure(let error):
                    print("Ошибка удаления: \(error)")
                }
            }
        }
    }
    
    private func loadCartItems() {
        cartService.loadCartItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.cartItems = items
                    if items.isEmpty {
                        self?.view?.showEmptyState()
                    } else {
                        self?.view?.displayCartItems(items)
                        self?.view?.updateTotalPrice()
                    }
                case .failure(let error):
                    print("Ошибка загрузки корзины: \(error)")
                    self?.view?.showEmptyState()
                }
            }
        }
    }
}
