//
//  CacheImageView.swift
//  FlickUp
//
//  Created by Prashant Pandey on 10/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

class CacheImageView: UIImageView {
    
    private var urlKey: String! = nil
    
    func loadImage(atURL url: URL, placeHolder: Bool = true, completion: (()-> Void)? = nil){
        
        self.urlKey = url.absoluteString
        if let cachedImage = CacheManager.shared.retrieveCachedImage(for: urlKey){
            completion?()
            self.image = cachedImage
            return
        }else{
            if placeHolder{
                self.image = UIImage(named: "flickr_placeholder")
            }
            
            NetworkManager.shared.download(fromURL: url) {[weak self, url] (data, error) in
                guard error == nil, let data = data else{
                    completion?()
                    return
                }
                
                if let image = UIImage(data: data){
                    //Cache image for future use
                    CacheManager.shared.cacheImage(image, forKey: url.absoluteString)
                    DispatchQueue.main.async {
                        completion?()
                        if url.absoluteString == self?.urlKey{
                            self?.image = image
                        }
                    }
                }else{
                    completion?()
                }
            }
        }
    }
    
    
}
