//
//  ImageLoaderServiceImpl.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import UIKit

// MARK: - ImageLoaderService
protocol ImageLoaderService {
    // MARK: - Public Methods
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

// MARK: - ImageLoaderServiceImpl
final class ImageLoaderServiceImpl: ImageLoaderService {

    // MARK: - Public Methods
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
