//
//  FlickUpSearchConstants.swift
//  FlickUp
//
//  Created by Prashant Pandey on 10/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation
import CoreGraphics

struct FlickUpSearchConstants {
    
    // MARK: View Configuration Constants
    
    static let cellPadding: CGFloat = 7.0
    static let numberOfColumns = 3
    static let cellIdentifier = "FlickUpImageCell"
    static let footerIdentifier = "FlickUpImageCellFooterView"
    static let itemsPerPage = 20
    
    struct Messages{
        static let itemsNeededAlertSheetMessage = "How many items should each row have?"
        static let searchDefaultPlaceholder = "Search"
    }
}

struct FlickUpAPIInteractorConstants {
    
    // MARK: API Constants
    
    static let apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    static let flickrAPIBaseURL = "https://api.flickr.com/services/rest/"
    static let stat = "stat"
    static let ok = "ok"
    static let photos = "photos"
    static let photo = "photo"
    static let id = "id"
    static let farm = "farm"
    static let server = "server"
    static let secret = "secret"
    struct Messages {
        static let searchURLCreationFailed = "Failed to create search URL."
        static let parsingFailed = "Failed to parse result."
    }
}
