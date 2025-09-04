//
//  ImageLoaderServiceImpl.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 04.09.2025.
//

import UIKit

// MARK: - Image Loading Service
protocol ImageLoaderService {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoaderServiceImpl: ImageLoaderService {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
