import Foundation

struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let image: String
    
    var symbol: String {
        if let range = image.range(of: "\\(([A-Z]+)\\)", options: .regularExpression) {
            let symbol = String(image[range])
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
            return symbol
        }
        return name
    }
    
    var displayName: String {
        return title.replacingOccurrences(of: "_", with: " ")
    }
}

typealias CurrenciesResponse = [Currency]

struct CurrencyApiResponse: Decodable {
    let success: Bool
    let data: [Currency]?
    let error: String?
}
