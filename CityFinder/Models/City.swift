//
//  City.swift
//  CityFinder
//
//  Created by D. on 2018-05-06.
//  Copyright © 2018 Lilia Dassine BELAID. All rights reserved.
//

import Foundation

struct City: Decodable {
    let _id: Int!
    let name: String!
    let country: String!
    let coord: Coordinates!
}
