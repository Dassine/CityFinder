//
//  CitiesTableViewController.swift
//  GeolocalizedCitiesList
//
//  Created by D. on 2018-05-05.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    private static let kJsonFileName:String = "cities"
    private static let kJsonFileExtension:String = "json"
    
    var cities = [City]()
    
    struct Coordinate: Decodable {
        let lat: Double!
        let lon: Double!
    }
    struct City: Decodable {
        let _id: Int!
        let name: String!
        let country: String!
        let coord: Coordinate!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCities()
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCities() {
        
        guard let url = Bundle.main.url(forResource:CitiesTableViewController.kJsonFileName, withExtension:CitiesTableViewController.kJsonFileExtension) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            
            self.cities = try JSONDecoder().decode([City].self, from: data)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch let jsonError {
            print("Error! Could not decode JSON: \(jsonError.localizedDescription)")
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseidentifier") ??
            UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: UIFontDescriptor.FeatureKey.typeIdentifier.rawValue)
        
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }

}
