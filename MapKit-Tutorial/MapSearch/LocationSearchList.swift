//
//  LocationSearchList.swift
//  MapKit-Tutorial
//
//  Created by Avisa on 20/8/19.
//  Copyright © 2019 Avisa. All rights reserved.
//

import UIKit
import MapKit



class LocationSearchList: UICollectionViewController, UICollectionViewDelegateFlowLayout,  UINavigationControllerDelegate {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    let searchCellId = "SearchCell"
    
    var matchingItems: [MKMapItem] = []
    
    var myMap: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
       collectionView.register(SearchCell.self, forCellWithReuseIdentifier: searchCellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return matchingItems.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCellId, for: indexPath) as! SearchCell
        
       let selectedItem = matchingItems[indexPath.item].placemark

        cell.textLabel.text = selectedItem.name
        
        cell.detailTextLabel.text = parseAddress(selectedItem: selectedItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
  fileprivate  func parseAddress(selectedItem: MKPlacemark) -> String {
    
    let firstSpace = (selectedItem.subThoroughfare != nil) && (selectedItem.thoroughfare != nil) ? " " : ""
    
    let comma = (selectedItem.subThoroughfare != nil) && (selectedItem.thoroughfare != nil) && (selectedItem.administrativeArea != nil) && (selectedItem.subAdministrativeArea != nil) ? ", " : ""
    
    let secondSpace = (selectedItem.administrativeArea != nil) && (selectedItem.subAdministrativeArea != nil) ? " " : ""
    
    let addresseLine = String (
        
        format:"%@%@%@%@%@%@%@",
        // street number
        selectedItem.subThoroughfare ?? "",
        firstSpace,
        // street name
        selectedItem.thoroughfare ?? "",
        comma,
        // city
        selectedItem.locality ?? "",
        secondSpace,
        // state
        selectedItem.administrativeArea ?? ""
        
    )
    
      return addresseLine
    }
    
    
    
}

extension LocationSearchList: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let myMap = myMap, let searchBarText = searchController.searchBar.text else { return }
        
        // MKLocalSearchRequest: A search request is comprised of a search string, and a map region that provides location context. The search string comes from the search bar text, and the map region comes from the mapView.
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = myMap.region
        
        //MKLocalSearch performs the actual search on the request object. startWithCompletionHandler() executes the search query and returns a MKLocalSearchResponse object which contains an array of mapItems. You stash these mapItems inside matchingItems, and then reload the list.
        
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            
            guard let response = response else {
                return
            }
            
            self.matchingItems = response.mapItems
            self.collectionView.reloadData()
        }
        
    }
    
    
}

extension LocationSearchList {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedItem = matchingItems[indexPath.item].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
    
        dismiss(animated: true, completion: nil)
    }
}
