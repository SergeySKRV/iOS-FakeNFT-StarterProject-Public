//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 02.09.2025.
//

import Foundation

extension String {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
