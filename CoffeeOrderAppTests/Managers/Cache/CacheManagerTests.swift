//
//  CacheManagerTests.swift
//  CoffeeOrderAppTests
//
//  Created by Mine Rala on 20.04.2025.
//

import XCTest

final class CacheManagerTests: XCTestCase {

    var mockCacheManager: MockCacheManager!

    override func setUp() {
        super.setUp()
        mockCacheManager = MockCacheManager()
    }

    override func tearDown() {
        mockCacheManager = nil
        super.tearDown()
    }

    func testGetImage_ReturnsImageFromCache() {
        // Given
        let testURL = "https://example.com/image.png"
        let testImage = UIImage()
        mockCacheManager.cacheImage(testImage, for: testURL)

        // When
        let cachedImage = mockCacheManager.getImage(for: testURL)

        // Then
        XCTAssertEqual(cachedImage, testImage)
    }


    func testLoadImage_CallsCompletionWithCachedImage() {
        // Given
        let testURL = "https://example.com/image.png"
        let testImage = UIImage()
        mockCacheManager.cacheImage(testImage, for: testURL)

        // When
        mockCacheManager.loadImage(from: testURL) { image in

            // Then
            XCTAssertEqual(image, testImage)
        }

        // Then: Assert that loadImage was called
        XCTAssertTrue(mockCacheManager.loadImageCalled)
    }


    func testLoadImage_ReturnsNilIfNoCachedImage() {
        // Given
        let testURL = "https://example.com/nonexistent.png"

        // When
        mockCacheManager.loadImage(from: testURL) { image in
            // Then: The completion block should be called with nil
            XCTAssertNil(image)
        }

        // Then
        XCTAssertTrue(mockCacheManager.loadImageCalled)
    }

}
