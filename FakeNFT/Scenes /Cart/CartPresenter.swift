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
        // Заглушка для оплаты
    }
    
    func deleteItem(at index: Int) {
        print("Удаление элемента по индексу: \(index) (заглушка)")
        // Пока просто удаляем из массива без сетевого запроса
        guard index < cartItems.count else { return }
        cartItems.remove(at: index)
        view?.displayCartItems(cartItems)
        view?.updateTotalPrice()
    }
    
    private func loadCartItems() {
        let testItems = [
            CartItem(id: "1", name: "April", image: "april_image", rating: 4, price: 1.78, currency: "ETH"),
            CartItem(id: "2", name: "Greena", image: "greena_image", rating: 5, price: 1.78, currency: "ETH"),
            CartItem(id: "3", name: "Spring", image: "spring_image", rating: 6, price: 1.78, currency: "ETH")
        ]
        
        self.cartItems = testItems
        if testItems.isEmpty {
            self.view?.showEmptyState()
        } else {
            self.view?.displayCartItems(testItems)
            self.view?.updateTotalPrice()
        }
    }
}
