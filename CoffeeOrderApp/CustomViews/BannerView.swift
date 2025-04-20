//
//  BannerView.swift
//  CoffeeOrderApp
//
//  Created by Mine Rala on 18.04.2025.
//

import UIKit
import SnapKit

final class BannerView: UIView, UIScrollViewDelegate {
    private lazy var bannerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var bannerPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemPurple
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    init(images: [String]) {
        super.init(frame: .zero)
        setupBannerView(with: images)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBannerView(with images: [String]) {
        addSubview(bannerScrollView)
        addSubview(bannerPageControl)

        bannerScrollView.delegate = self

        bannerScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        var previousImageView: UIImageView?

        for (index, imageName) in images.enumerated() {
            let bannerImageView = UIImageView(image: UIImage(named: imageName))
            bannerImageView.contentMode = .scaleToFill
            bannerImageView.clipsToBounds = true
            bannerScrollView.addSubview(bannerImageView)

            bannerImageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(self.snp.width)
                make.height.equalToSuperview()

                if let previous = previousImageView {
                    make.left.equalTo(previous.snp.right)
                } else {
                    make.left.equalToSuperview()
                }

                if index == images.count - 1 {
                    make.right.equalToSuperview()
                }
            }

            previousImageView = bannerImageView
        }

        bannerPageControl.numberOfPages = images.count
        bannerPageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        bannerPageControl.currentPage = pageIndex
    }
}

