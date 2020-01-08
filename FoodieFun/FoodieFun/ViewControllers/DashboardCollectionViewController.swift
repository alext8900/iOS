//
//  DashboardCollectionViewController.swift
//  FoodieFun
//
//  Created by Vici Shaweddy on 12/25/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RestaurantCell"

class DashboardCollectionViewController: UICollectionViewController {
    
    let loginController = LoginController.shared
    let restaurantController = RestaurantController()
    
    // Telling search controller for using the same view to display the results by using nil value
    let searchController = UISearchController(searchResultsController: nil)
    
    // Hold the restaurants that the user is searching for
    var filteredRestaurant = [Restaurant]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Communication between Add tab and Home tab
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData), name: .restaurantDidSaveNotification, object: nil)
        
        self.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loginController.token?.token != nil {
            restaurantController.fetchAllRestaurants { (result) in
                if let createdRestaurants = try? result.get() {
                    DispatchQueue.main.async {
                        self.restaurantController.restaurants = createdRestaurants
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Private Functions
    // For reloading data after a new restaurant is created from the Add VC
    @objc func onDidReceiveData(_ notification: Notification) {
       if loginController.token?.token != nil {
           restaurantController.fetchAllRestaurants { (result) in
               if let createdRestaurants = try? result.get() {
                   DispatchQueue.main.async {
                       self.restaurantController.restaurants = createdRestaurants
                       self.collectionView.reloadData()
                   }
               }
           }
       }
    }
    
    // for Search Functionality
    
    func search() {
        // Set up the search controller
        // Allows the class to be informed as text changes within the UISearchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Restaurant"
        navigationItem.searchController = searchController
        
        // Ensure the serach bar does not remain on the screen if the user navigates to another view controller
        definesPresentationContext = true
    }
    
    func aRestaurant(_ keyword: String) -> [Restaurant] {
        let restaurants = self.restaurantController.restaurants
        
        return restaurants.filter { (restaurant) -> Bool in
            restaurant.name == keyword || restaurant.location == keyword || restaurant.cuisine == keyword
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredRestaurant = restaurantController.restaurants.filter({ (restaurant: Restaurant) -> Bool in
            return restaurant.name.lowercased().contains(searchText.lowercased()) ||
                restaurant.location.lowercased().contains(searchText.lowercased()) ||
                restaurant.cuisine.lowercased().contains(searchText.lowercased()) == true
        })
        collectionView.reloadData()
    }
    
    // Filtering results or not
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            guard let restaurantVC = segue.destination as?
            DetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            restaurantVC.restaurantController = restaurantController
            restaurantVC.restaurant = restaurantController.restaurants[indexPath.item]
        }
        
//        if segue.identifier == "DetailSegue"
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredRestaurant.count
        }
        
        return restaurantController.restaurants.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RestaurantCollectionViewCell else { return UICollectionViewCell() }
    
        let restaurant: Restaurant
        if isFiltering() {
            restaurant = filteredRestaurant[indexPath.item] // search view
        } else {
            restaurant = restaurantController.restaurants[indexPath.item] // default
        }
        
        // updating UIs
        cell.imageView.image = UIImage(named: "fried chicken") ?? UIImage(named: "placeholder")
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension DashboardCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 3 * 20) / 2
        return CGSize(width: width, height: 1.2 * width)
    }
}

extension DashboardCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}



