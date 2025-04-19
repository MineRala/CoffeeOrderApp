//
//  CacheManager.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import Foundation
import UIKit

protocol CacheManagerInterface {
    func getImage(for url: String) -> UIImage?
    func cacheImage(_ image: UIImage, for url: String)
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void)
}

final class CacheManager: CacheManagerInterface {
    static let shared = CacheManager()
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}

    func getImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }

    func cacheImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = getImage(for: url) {
            completion(cachedImage)
            return
        }

        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }

            self.cacheImage(image, for: url)

            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
