//
//  ImageLoaderService.swift
//  FakeNFT
//
//  Created by Сергей Скориков on 19.09.2025.
//

import UIKit

protocol ImageLoaderService {
    /// Загружает изображение по URL-строке.
    /// - Parameters:
    ///   - urlString: Строка с URL.
    ///   - completion: Колбэк с результатом (`UIImage?`).
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoaderServiceImpl: ImageLoaderService {
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self?.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async { completion(image) }
        }
        .resume()
    }
}
