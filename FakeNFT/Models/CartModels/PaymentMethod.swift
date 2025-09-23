import Foundation

struct PaymentMethod {
    let currency: Currency
    var isSelected: Bool = false
}

extension PaymentMethod {
    static func fromCurrencies(_ currencies: [Currency]) -> [PaymentMethod] {
        return currencies.map { PaymentMethod(currency: $0) }
    }
}
