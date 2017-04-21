//
//  UserProfilesViewController.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/21/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class UserProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var profilesTableView: UITableView!
    var userProfiles: [UserProfile] = []
    var activeProfiles: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        setupTableView()
        setupUserProfiles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.profilesTableView.reloadData()
    }
    
    func addTapped() {
        self.navigationController?.pushViewController(UserPreferencesViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        self.profilesTableView = UITableView()
        self.profilesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        self.profilesTableView.frame = self.view.frame
        self.profilesTableView.delegate = self
        self.profilesTableView.dataSource = self
        self.profilesTableView.reloadData()
        self.view.addSubview(self.profilesTableView)
    }
    
    func setupUserProfiles() {
    }
    
    func compilePreferences() -> UserProfile {
        var averageRating = 0
        var averageRadius = 0.0
        var priceRanges = [true, true, true, true]
        var count = 0
        var typeString = ""
        
        for index in 0...userProfiles.count-1 {
            if self.activeProfiles[index] {
                count += 1
                let profile = self.userProfiles[index]
                averageRating += profile.rating
                averageRadius += profile.maxDistance
                for priceIndex in 0...3 {
                    if !profile.priceRanges[priceIndex] {
                        priceRanges[priceIndex] = false
                    }
                }
                if (profile.type != "All Restaurants"){
                    typeString.append(profile.type + ",")
                }
            }
        }
        if count == 0 {
            // return default
            return UserProfile()
        }
        
        averageRating = averageRating / count
        averageRadius = averageRadius / Double(count)
        
        return UserProfile(userID: -1, username: "", rating: averageRating, priceRanges: priceRanges, maxDistance: averageRadius, type: typeString)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfiles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            self.activeProfiles[indexPath.row] = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.activeProfiles[indexPath.row] = true
        }
        
        let compiled = compilePreferences()
        print(compiled.maxDistance)
        print(compiled.priceRanges)
        print(compiled.rating)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = self.userProfiles[indexPath.row].username
        return cell
    }
}
