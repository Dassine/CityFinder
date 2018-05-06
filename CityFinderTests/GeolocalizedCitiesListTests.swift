//
//  GeolocalizedCitiesListTests.swift
//  GeolocalizedCitiesListTests
//
//  Created by D. on 2018-05-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import XCTest
@testable import GeolocalizedCitiesList

class GeolocalizedCitiesListTests: XCTestCase {
    let kJsonFileName = "citiesTest"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func citiesViewControllerInstance() -> CitiesViewController {
        // Get Cities View Controller and load the view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let citiesViewController = storyboard.instantiateViewController(withIdentifier: "CitiesViewController") as! CitiesViewController
        citiesViewController.loadView()
        
        return citiesViewController
    }
    
    func setSearch(text:String, on viewController:CitiesViewController) {
        
        // Filter contente for the search text
        viewController.searchController.searchBar.text = searchText
        viewController.filterContentForSearchText(searchText)
    }
    
    func testTextSearch() {
        // Set the cities View Controller and get the data from the test JSON file containing the 5 cities provided in the assignment
        let citiesViewController = citiesViewControllerInstance()
        citiesViewController.getCities(from: kJsonFileName)
        
        // Set the timer according to asynch fetch and display of the search results
        let maxAllowedTimeForFinishSearching = UInt32(1)
        
        // If the given prefix is 'A', all cities but Sydney should appear.
        
        setSearch(text: "A", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 4, "All rows but Sidney should appear")
        
        // If the given prefix is “s”, the only result should be “Sydney, AU”.
        setSearch(text: "s", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 1, "Only Sydney should appear")
        
        
        // If the given prefix is “Al”, “Alabama, US” and “Albuquerque, US” are the only results.
        setSearch(text: "Al", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 2, "Alabama, US and Albuquerque, US should appear")
        
        // If the prefix given is “Alb” then the only result is “Albuquerque, US”
        setSearch(text: "Alb", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 1, "Albuquerque only should appear")
        
        // If the prefix given is an unknown city name then the no result should be found
        setSearch(text: "unknown city!!", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 0, "No results should be found")
        
        // If the prefix is emplty all the cities should appear
        setSearch(text: "", on: citiesViewController)
        sleep(maxAllowedTimeForFinishSearching)
        assert(citiesViewController.tableView(citiesViewController.tableView, numberOfRowsInSection: 0) == 5, "All citie should appear")
    }
    
}
