import Foundation

enum SortOption: String {
    case price = "price"
    case rating = "rating"
    case name = "name"
    case `default` = "default"
}

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    private let cartService: CartServiceProtocol
    
    private var cartItems: [CartItem] = []
    private var originalItems: [CartItem] = []
    private var currentSortOption: SortOption = .name {
        didSet {
            UserDefaults.standard.set(currentSortOption.rawValue, forKey: "CartSortOption")
        }
    }
    
    init(view: CartViewProtocol, cartService: CartServiceProtocol) {
        self.view = view
        self.cartService = cartService
        loadSavedSortOption()
    }
    
    func viewDidLoad() {
        loadCartItems()
    }
    
    func payButtonTapped() {
        guard !cartItems.isEmpty else {
            view?.showError(message: "Корзина пуста")
            return
        }
        view?.navigateToPaymentScreen()
    }
    
    func deleteItem(at index: Int) {
        guard index < cartItems.count else { return }
        let itemId = cartItems[index].id
        let itemToDelete = cartItems[index]
        let currentItems = cartItems
        
        cartItems.remove(at: index)
        applyCurrentSort()
        view?.displayCartItems(cartItems)
        view?.updateTotalPrice()
        
        cartService.deleteItemFromCart(itemId: itemId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if self?.cartItems.isEmpty == true {
                        self?.view?.showEmptyState()
                    }
                    
                case .failure(let error):
                    self?.cartItems = currentItems
                    self?.applyCurrentSort()
                    self?.view?.displayCartItems(self?.cartItems ?? [])
                    self?.view?.updateTotalPrice()
                    self?.view?.showError(message: "Не удалось удалить элемент")
                }
            }
        }
    }
    
    func sortItems(by option: SortOption) {
        currentSortOption = option
        applyCurrentSort()
        view?.displayCartItems(cartItems)
    }
    
    private func loadCartItems() {
        cartService.loadCartItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.cartItems = items
                    self?.originalItems = items
                    self?.applyCurrentSort()
                    
                    if items.isEmpty {
                        self?.view?.showEmptyState()
                    } else {
                        self?.view?.displayCartItems(self?.cartItems ?? [])
                        self?.view?.updateTotalPrice()
                    }
                case .failure(let error):
                    print("Ошибка загрузки корзины: \(error)")
                    self?.view?.showEmptyState()
                }
            }
        }
    }
    
    private func applyCurrentSort() {
        switch currentSortOption {
        case .price:
            cartItems.sort { $0.price < $1.price }
        case .rating:
            cartItems.sort { $0.rating > $1.rating }
        case .name, .default:
            cartItems.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    private func loadSavedSortOption() {
        if let savedValue = UserDefaults.standard.string(forKey: "CartSortOption"),
           let savedOption = SortOption(rawValue: savedValue) {
            currentSortOption = savedOption
        }
    }
}
