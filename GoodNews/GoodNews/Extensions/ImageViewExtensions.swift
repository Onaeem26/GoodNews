//
//  ImageViewExtensions.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 3/17/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

//let imageCache = NSCache<AnyObject, AnyObject>()
//let cachedImages = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(at urlString: String) {
        let urlConverted = URL(string: urlString)
        if let url = urlConverted {
            UIImageLoader.loader.load(url, for: self)
        }
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}

