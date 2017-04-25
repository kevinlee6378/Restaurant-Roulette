//
//  MenuViewController.swift
//  Restaurant Roulette
//
//  Created by Labuser on 4/2/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit
import MapKit

class MenuViewController: UIViewController {
    var buttonArray: [UIButton] = [UIButton]()
    var viewsArray: [UIViewController] = [UIViewController]()
    
    var latitude: String?
    var longitude: String?
    var minRatings = 3
    var searchRadius = 5.0
    var prices = [true, true, false, false]
    var type = "all"

    var locButton: UIButton!
    var prefButton: UIButton!
    var profilesButton: UIButton!
    var wheelButton: UIButton!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        addDummyViews()
        self.imageView = UIImageView()
        //self.imageView.backgroundColor = .black
        self.imageView.image = #imageLiteral(resourceName: "girl_wheel")
        let length = self.view.frame.height/2 - 60
        self.imageView.frame = CGRect(x: (self.view.frame.width - length)/2, y: 30, width: length, height: length)
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        let width = CGFloat(200)
        //let height = CGFloat(50)
        let padding = self.view.frame.height/30
       // let padding = CGFloat(self.view.frame.height / 20)
        let height = 2*padding
        var currY = self.view.frame.height / 2 - padding
        let x = (self.view.frame.width - width) / 2
        
        self.locButton = UIButton()
        self.locButton.setTitle("Choose your location", for: UIControlState.normal)
        self.buttonArray.append(self.locButton)
        
        self.prefButton = UIButton()
        self.prefButton.setTitle("Pick your preferences", for: UIControlState.normal)
        self.buttonArray.append(self.prefButton)
        
        self.profilesButton = UIButton()
        self.profilesButton.setTitle("User Profiles", for: UIControlState.normal)
        self.buttonArray.append(self.profilesButton)
        
        self.wheelButton = UIButton()
        self.wheelButton.setTitle("Find a restaurant", for: UIControlState.normal)
        self.buttonArray.append(self.wheelButton)
        
        var buttonIndex = 0
        for button in self.buttonArray {
            button.tag = buttonIndex
            buttonIndex += 1
            button.frame = CGRect(x:x, y:currY, width:width, height:height)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
            currY += height + padding
        }
        
    }
    
    func buttonClicked(sender:UIButton) {
        if (sender.tag == 3){
            let profilesVC = self.viewsArray[2] as! UserProfilesViewController
            let compiledProfile = profilesVC.compilePreferences()
            if (compiledProfile.userID == -1){
                let wheelVC = self.viewsArray[3] as! WheelViewController
                wheelVC.latitude = self.latitude!
                wheelVC.longitude = self.longitude!
                wheelVC.minRating = compiledProfile.rating
                wheelVC.searchRadius = Int(compiledProfile.maxDistance * 1609.34)
                wheelVC.prices = compiledProfile.priceRanges
                wheelVC.type = compiledProfile.type
            }
            else {
                let wheelVC = self.viewsArray[3] as! WheelViewController
                //print(self.latitude!)
                //print(self.longitude!)
                wheelVC.latitude = self.latitude!
                wheelVC.longitude = self.longitude!
                wheelVC.minRating = self.minRatings
                wheelVC.searchRadius = Int(self.searchRadius * 1609.34)
                wheelVC.prices = self.prices
                wheelVC.type = self.type
            }
        }
        //print(latitude)
        //print(longitude)
        //print(minRatings)
        //print(searchRadius)
        //for b in prices {
         //   print(b)
        //}
        //print(self.type)
        self.navigationController?.pushViewController(self.viewsArray[sender.tag], animated: true)
        //print(self.searchRadius)
    }
    
    func addDummyViews() {
        
        let dummyController1 = LocationViewController()
        dummyController1.view.backgroundColor = UIColor.red
        self.viewsArray.append(dummyController1)
        
        let dummyController2 = PreferencesViewController()
        dummyController2.view.backgroundColor = UIColor.white
        self.viewsArray.append(dummyController2)
        
        let dummyController4 = UserProfilesViewController()
        //dummyController3.view.backgroundColor = UIColor.blue
        self.viewsArray.append(dummyController4)
        
        let dummyController3 = WheelViewController()
        //dummyController3.view.backgroundColor = UIColor.blue
        self.viewsArray.append(dummyController3)
        
    }
    
    func disableButton(button:UIButton) {
        button.isUserInteractionEnabled = false
        button.titleLabel?.textColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func enableButton(button:UIButton) {
        button.isUserInteractionEnabled = true
        button.titleLabel?.textColor = UIColor.black.withAlphaComponent(1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(longitude! + " " + latitude!)
        if let longitude = self.longitude {
            if let latitude = self.latitude {
                //print(longitude + " " + latitude)
                enableButton(button: self.wheelButton)
                enableButton(button: self.prefButton)
            }
        } else {
            disableButton(button: self.wheelButton)
            disableButton(button: self.prefButton)
        }
        
    }
    
}
