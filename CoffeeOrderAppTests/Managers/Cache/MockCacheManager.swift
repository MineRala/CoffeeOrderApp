//
//  MockCacheManager.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import UIKit
@testable import CoffeeOrderApp


final class MockCacheManager: CacheManagerProtocol {
    var cachedImages: [String: UIImage] = [:]
    var loadImageCalled = false
    var cachedImage: UIImage?
    var loadImageCompletion: ((UIImage?) -> Void)?

    func getImage(for url: String) -> UIImage? {
        return cachedImages[url]
    }

    func cacheImage(_ image: UIImage, for url: String) {
        cachedImages[url] = image
    }

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        loadImageCalled = true
        loadImageCompletion = completion

        if let image = cachedImages[url] {
            completion(image)
        } else {
            completion(nil)
        }
    }
}
