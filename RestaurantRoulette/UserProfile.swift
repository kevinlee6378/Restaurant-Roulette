//
//  UserProfile.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/21/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import Foundation

class UserProfile {
    var userID: Int
    var username: String!
    var rating: Int!
    var priceRanges: [Bool]!
    var maxDistance: Int!
    
    init(userID: Int, username: String, rating: Int, priceRanges: [Bool], maxDistance: Int) {
        self.userID = userID
        self.username = username
        self.rating = rating
        self.priceRanges = priceRanges
        self.maxDistance = maxDistance
    }
    
    init() {
        self.userID = 0
        self.username = ""
        self.rating = 0
        self.priceRanges = [true, true, true, true]
        self.maxDistance = 5
    }
}
