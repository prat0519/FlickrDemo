//
//  FlickUpPhoto.swift
//  FlickUp
//
//  Created by Prashant Pandey on 11/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation

struct FlickUpPhoto: Photo {
    
    let photoID : String
    let server : String
    let secret : String
    let farm : Int
    
    var thumbnailImageURL: URL? {
        get{
            //q size suffix stands for large square 150x150 size image
            if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_q.jpg") {
                return url
            }
            return nil
        }
    }
    
    var highResImageURL: URL?{
        get{
            // b size suffix stands for a high resolution photo
            if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_b.jpg") {
                return url
            }
            return nil
        }
    }
}
