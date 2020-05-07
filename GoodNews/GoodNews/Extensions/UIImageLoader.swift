//
//  UIImageLoader.swift
//  GoodNews
//
//  Created by Muhammad Osama Naeem on 5/4/20.
//  Copyright © 2020 Muhammad Osama Naeem. All rights reserved.
//

import UIKit

class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {
        NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [weak self] notification in
            self?.clearCache()
         }
    }
    
    func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.loadImage(url) { result in
            
            defer {self.uuidMap.removeValue(forKey: imageView)}
            
            do {
                let image = try result.get()
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }catch {
                //Handle error here
            }
            
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
      if let uuid = uuidMap[imageView] {
        imageLoader.cancelLoad(uuid)
        uuidMap.removeValue(forKey: imageView)
      }
    }
    
    func clearCache() {
        self.imageLoader.removeMemoryCache()
    }
}
