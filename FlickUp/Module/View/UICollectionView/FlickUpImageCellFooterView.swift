//
//  FlickUpImageCellFooterView.swift
//  FlickUp
//
//  Created by Prashant Pandey on 08/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

class FlickUpImageCellFooterView: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
    }
}
