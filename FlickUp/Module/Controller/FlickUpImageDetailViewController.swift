//
//  FlickUpImageDetailViewController.swift
//  FlickUp
//
//  Created by Prashant Pandey on 10/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

class FlickUpImageDetailViewController: UIViewController {

    var photo: Photo? = nil

    @IBOutlet weak var imageViewDetail: CacheImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.activityIndicator.stopAnimating()

        if let _ = photo, let highResImageURL = photo?.highResImageURL{
            if CacheManager.shared.isImageCached(for: highResImageURL.absoluteString){
                imageViewDetail.loadImage(atURL: highResImageURL)
            } else if let thumbnailImageURL = photo?.thumbnailImageURL{
                imageViewDetail.loadImage(atURL: thumbnailImageURL)
                activityIndicator.startAnimating()
                imageViewDetail.loadImage(atURL: highResImageURL, placeHolder: false, completion: {[weak self] in
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
