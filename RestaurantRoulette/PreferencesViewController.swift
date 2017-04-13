//
//  PreferencesViewController.swift
//  RestaurantRoulette
//
//  Created by Labuser on 4/13/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var preferenceNames:[String] = []
    var tableView:UITableView!
    
    var ratingSlider: UISlider!
    var ratingLabel: UITextView!
    var ratingStarsImageView: UIImageView!
    var ratingStarsImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addStarAssests()
        self.setupPreferences()
        self.setupTableView()
        self.setupRating()
        print(self.preferenceNames)
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPreferences() {
        self.preferenceNames.append("Preference 1")
        self.preferenceNames.append("Preference 2")
    }
    
    func setupRating() {
        self.ratingSlider = UISlider()
        self.ratingSlider.minimumValue = 1
        self.ratingSlider.maximumValue = 5
        self.ratingSlider.isContinuous = true
        self.ratingSlider.value = 1
        let width = self.view.frame.width - 60
        let height = 100
        //self.ratingSlider.frame = self.view.frame
        self.ratingSlider.frame = CGRect(x: 30, y: 30, width: Int(width), height: height)
        self.ratingSlider.addTarget(self, action: #selector(ratingDidChange(sender:)), for: .valueChanged)
        self.view.addSubview(self.ratingSlider)
        
//        self.ratingLabel = UITextView()
//        self.ratingLabel.frame = CGRect(x: 30, y: 130, width: Int(width), height: height)
//        self.view.addSubview(self.ratingLabel)
        
        self.ratingStarsImageView = UIImageView()
        self.ratingStarsImageView.frame = CGRect(x: 30, y: 130, width: Int(width), height: height)
        self.ratingStarsImageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.ratingStarsImageView)
        
    }
    
    func addStarAssests() {
        self.ratingStarsImages.append(UIImage(named: "regular_1")!)
        self.ratingStarsImages.append(UIImage(named: "regular_1_half")!)
        self.ratingStarsImages.append(UIImage(named: "regular_2")!)
        self.ratingStarsImages.append(UIImage(named: "regular_2_half")!)
        self.ratingStarsImages.append(UIImage(named: "regular_3")!)
        self.ratingStarsImages.append(UIImage(named: "regular_3_half")!)
        self.ratingStarsImages.append(UIImage(named: "regular_4")!)
        self.ratingStarsImages.append(UIImage(named: "regular_4_half")!)
        self.ratingStarsImages.append(UIImage(named: "regular_5")!)
    }
    
    func ratingDidChange(sender: UISlider!) {
        self.ratingStarsImageView.image = ratingStarsImages[Int(2*round(ratingSlider.value*2)/2.0 - 2)]
    }
    
    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = self.view.frame
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PreferenceCell")
        //self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.preferenceNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("load cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferenceCell", for: indexPath as IndexPath) as UITableViewCell;
        cell.textLabel?.text = self.preferenceNames[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    

}
