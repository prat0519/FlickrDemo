//
//  CacheManager.swift
//  FlickUp
//
//  Created by Prashant Pandey on 10/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

class CacheManager {
    static let shared: CacheManager = CacheManager()
    private let imageCache: NSCache<NSString, UIImage>
    private init(){
        imageCache = NSCache<NSString, UIImage>()
    }
    
    func retrieveCachedImage(for key: String) -> UIImage?{
        return self.imageCache.object(forKey: key as NSString)
    }
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        self.imageCache.setObject(image, forKey: key as NSString)
    }
    
    func isImageCached(for key: String) -> Bool{
        if let _ = self.retrieveCachedImage(for: key){
            return true
        }
        return false
    }
}
