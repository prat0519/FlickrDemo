//
//  FlickUpSearchViewController.swift
//  FlickUp
//
//  Created by Prashant Pandey on 08/08/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import UIKit

protocol Photo {
    var thumbnailImageURL: URL? {get}
    var highResImageURL: URL? {get}
}

protocol FlickUpSearchControllerProtocol {
    
    func searchPhotos(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping ([Photo]?, String?)-> Void)
}
class FlickUpSearchViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewFlickr: UICollectionView!
    
    fileprivate var photosDataSource: [Photo]? = nil
    fileprivate var delegate: FlickUpSearchControllerProtocol? = nil
    fileprivate var itemsPerRow = FlickUpSearchConstants.numberOfColumns
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var searchString: String? = nil
    fileprivate var searckTask: DispatchWorkItem? = nil
    fileprivate var isLoading: Bool = false
    fileprivate var zooimingCellIndexPath: IndexPath? = nil
    fileprivate var isFulfillingSearchConditions: Bool{
        get{
            if let searchText = searchController.searchBar.text{
                searchString = searchText
                return true
            }else{
                return false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Flickr Search"

        delegate = FlickUpSearchInteractor()

        //configure searchController
        configureSearchController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: configureSearchController
    
    private func configureSearchController() {
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search flickr for your favourite images"
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.titleView?.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? FlickUpImageCell,
            let indexPath = self.collectionViewFlickr?.indexPath(for: cell) {
            zooimingCellIndexPath = indexPath
            
            guard let detailViewController = segue.destination as? FlickUpImageDetailViewController else{ return }
            detailViewController.photo = photosDataSource![indexPath.item]
        }
    }
    
    fileprivate func search(forPage pageNumber: Int, completion:@escaping ([Photo]?)->Void){
        guard let searchString = searchString else{return}
        delegate?.searchPhotos(forSearchString: searchString, pageNumber: pageNumber, andItemsPerPage: FlickUpSearchConstants.itemsPerPage, completion: {[weak self](results, error) in
            self?.isLoading = false
            DispatchQueue.main.async {
                if error != nil || results?.count == 0{
                    self?.showError(error: error ?? "No Results Found")
                }else{
                    completion(results)
                }
                self?.collectionViewFlickr?.reloadData()
            }
        })
        isLoading = true
    }
    
    @objc fileprivate func searchNextPage(){
        let currentPage = (photosDataSource?.count ?? 0)/FlickUpSearchConstants.itemsPerPage
        search(forPage: currentPage+1, completion:{[weak self] (results) in
            guard let results = results else {return}
            self?.photosDataSource?.append(contentsOf: results)
        })
    }
    
    fileprivate func showError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { action in
            self.searchController.searchBar.placeholder = FlickUpSearchConstants.Messages.searchDefaultPlaceholder
            self.searchString = nil
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDataSource implementation
extension FlickUpSearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photosDataSource?.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickUpSearchConstants.cellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photosDataSource![indexPath.item]
        (cell as! FlickUpImageCell).loadImageData(photo)
        
        guard let currentDataSourceSize = photosDataSource?.count else{return}
        if currentDataSourceSize - indexPath.row == (2 * itemsPerRow){
            searchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as! FlickUpImageCell).reducePriorityOfDownloadtaskForCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FlickUpSearchConstants.footerIdentifier, for: indexPath) as! FlickUpImageCellFooterView
        isLoading ? footerView.activityIndicator.startAnimating(): footerView.activityIndicator.stopAnimating()
        return footerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FlickUpSearchViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let paddingPerRow = FlickUpSearchConstants.cellPadding * CGFloat(itemsPerRow - 1)
        let availableSpace = self.view.frame.width - paddingPerRow
        let dimensionOfEachItem = availableSpace/CGFloat(itemsPerRow)
        
        return CGSize(width: dimensionOfEachItem, height: dimensionOfEachItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FlickUpSearchConstants.cellPadding
    }
}

extension FlickUpSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isFulfillingSearchConditions {
            search(forPage: 0, completion: {[weak self] results in
                guard let results = results else{return}
                self?.photosDataSource = results

            })
            self.photosDataSource?.removeAll()
            self.collectionViewFlickr?.reloadData()
            
            searchController.isActive = false
            searchBar.placeholder = searchString
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = FlickUpSearchConstants.Messages.searchDefaultPlaceholder
    }
}

