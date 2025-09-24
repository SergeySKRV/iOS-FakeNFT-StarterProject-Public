//
//  AlertCatalogView.swift
//  FakeNFT
//
//  Created by Dmitry Batorevich on 16.09.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let actionTitles: [String]
}

protocol AlertCatalogView {
    func openAlert(
        title: String,
        message: String?,
        alertStyle: UIAlertController.Style,
        actionTitles: [String],
        actionStyles: [UIAlertAction.Style],
        actions: [((UIAlertAction) -> Void)]
    )
}

