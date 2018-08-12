//
//  FlickUpImageCell.swift
//  FlickUp
//
//  Created by Prashant Pandey on 08/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

class FlickUpImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFlickr: CacheImageView!

    var photo: Photo? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewFlickr.layer.cornerRadius = CGFloat(FlickUpSearchConstants.numberOfColumns*3)
    }
    
    func loadImageData(_ data: Photo?) {
        photo = data
        guard let photo = photo, let thumbnailImageURL = photo.thumbnailImageURL else {
            return
        }
        self.imageViewFlickr.loadImage(atURL: thumbnailImageURL)
    }
    
    override func prepareForReuse() {
        self.imageViewFlickr.image = nil
    }
    
    func reducePriorityOfDownloadtaskForCell(){
        guard let photo = photo, let thumbnailImageURL = photo.thumbnailImageURL else {
            return
        }
        NetworkManager.shared.reducePriorityOfTask(withURL: thumbnailImageURL)
    }
}
