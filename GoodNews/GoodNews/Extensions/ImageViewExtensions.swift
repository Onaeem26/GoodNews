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

//    func loadImageUsingCacheWithUrlString(urlString:String) {
//
//        self.image = nil
//
//        //Check cache for image first
//        if let cacheImage = cachedImages.object(forKey: urlString as NSString)  {
//            self.image = cacheImage
//            return
//        }
//
//        //Otherwise fire off a new download
//        guard let url = URL(string: urlString) else { return }
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            DispatchQueue.main.async {
//                if let downloadedImage = UIImage(data:data!){
//                    cachedImages.setObject(downloadedImage, forKey: urlString as NSString)
//                    self.image = downloadedImage
//                }
//            }
//        })
//
//        task.resume()
//    }
    
}

