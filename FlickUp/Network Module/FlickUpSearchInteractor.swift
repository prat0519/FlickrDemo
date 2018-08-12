//
//  FlickUpSearchInteractor.swift
//  FlickUp
//
//  Created by Prashant Pandey on 10/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation

class FlickUpSearchInteractor : FlickUpSearchControllerProtocol {
    func searchPhotos(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping ([Photo]?, String?)-> Void){
        guard let flickrSearchURL = searchURL(forSearchString: searchString, pageNumber: pageNumber, andItemsPerPage: itemsPerPage) else{
            completion(nil, FlickUpAPIInteractorConstants.Messages.searchURLCreationFailed)
            return
        }
        
        NetworkManager.shared.request(withURL: flickrSearchURL, completion:{[weak self] (data, error) in
            if let _ = error {
                completion(nil, error.debugDescription)
            }else{
                if let results = self?.parseFlickrSearchResult(data){
                    completion(results, nil)
                }else{
                    completion(nil, FlickUpAPIInteractorConstants.Messages.parsingFailed)
                }
            }
        })
    }
    
    private func searchURL(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int) -> URL?{
        
        guard let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let URLString = "\(FlickUpAPIInteractorConstants.flickrAPIBaseURL)?method=flickr.photos.search&api_key=\(FlickUpAPIInteractorConstants.apiKey)&text=\(escapedSearchString)&per_page=\(itemsPerPage)&page=\(pageNumber)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: URLString) else { return nil }
        
        return url
    }
    
    private func parseFlickrSearchResult(_ data: Data?) -> [FlickUpPhoto]?{
        guard let data = data else{return nil}
        
        do {
            guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                let stat = resultsDictionary[FlickUpAPIInteractorConstants.stat] as? String else  {return nil}
            
            if stat == FlickUpAPIInteractorConstants.ok {
                guard let photosContainer = resultsDictionary[FlickUpAPIInteractorConstants.photos] as? [String: AnyObject], let photosReceived = photosContainer[FlickUpAPIInteractorConstants.photo] as? [[String: AnyObject]] else {return nil}
                
                var flickrPhotos = [FlickUpPhoto]()
                
                for photoObject in photosReceived {
                    guard let photoID = photoObject[FlickUpAPIInteractorConstants.id] as? String,
                        let farm = photoObject[FlickUpAPIInteractorConstants.farm] as? Int ,
                        let server = photoObject[FlickUpAPIInteractorConstants.server] as? String ,
                        let secret = photoObject[FlickUpAPIInteractorConstants.secret] as? String else { break }
                    
                    let flickrPhoto = FlickUpPhoto(photoID: photoID, server: server, secret: secret, farm: farm)
                    
                    flickrPhotos.append(flickrPhoto)
                }
                return flickrPhotos
            }
        } catch _ {
            return nil
        }
        return nil
    }
}
