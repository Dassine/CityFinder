//
//  CitiesTableViewController.swift
//  CityFinder
//
//  Created by D. on 2018-05-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private static let kJsonFileName:String = "cities"
    private static let kJsonFileExtension:String = "json"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooterView!
    
    var cities = [City]()
    var filteredCities = [City]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The list of cities will be displayed as a compact table view, scrollable list, easy to select items and simple forwards/backwards navigtaion. This regarding the content available to display. The search will be available by pulling down the as disigned for Mail, Apple app.
        
        // Get Cities from Json File
        getCities(from: CitiesViewController.kJsonFileName)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cities"
        searchController.searchBar.delegate = self
        searchController.searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        // Remove left EdgeInsets of tabkeView
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        // Disable double selection
        tableView.isMultipleTouchEnabled = false
        
    }
    
    // MARK: - Extract data method
    
    func getCities(from fileName: String) {
        
        cities.removeAll()
        filteredCities.removeAll()
        
        guard let url = Bundle.main.url(forResource:fileName, withExtension:CitiesViewController.kJsonFileExtension) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            
            cities = try JSONDecoder().decode([City].self, from: data).sorted(by: { ($0.name) < ($1.name) })
            filteredCities = cities
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch let jsonError {
            print("Error! Could not decode JSON: \(jsonError.localizedDescription)")
        }
    }
    
    // MARK: - Filtering/Search methods
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCities = cities.filter({( city ) -> Bool in
            return city.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    // MARK: - Table View
    
    func dataSource() -> [City] {
        return !isFiltering() ? cities : filteredCities
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredCities.count, of: cities.count)
            return filteredCities.count
        }
        
        searchFooter.setNotFiltering()
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") ??
            UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: UIFontDescriptor.FeatureKey.typeIdentifier.rawValue)
        
        let city = dataSource()[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = dataSource()[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "ShowMapViewController", sender: city)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapViewController",
            let mapViewController = segue.destination as? MapViewController,
            let city = sender as? City {
            mapViewController.city = city
        }
    }
}

extension CitiesViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension CitiesViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
