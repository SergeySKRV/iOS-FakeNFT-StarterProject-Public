//
//  UIView+addSubviews.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 10.09.2025.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_
                     subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
