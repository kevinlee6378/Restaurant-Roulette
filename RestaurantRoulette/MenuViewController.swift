//
//  MenuViewController.swift
//  Restaurant Roulette
//
//  Created by Labuser on 4/2/17.
//  Copyright © 2017 wustl. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var buttonArray: [UIButton] = [UIButton]()
    var viewsArray: [UIViewController] = [UIViewController]()
    
    var locButton: UIButton!
    var prefButton: UIButton!
    var wheelButton: UIButton!
    
    
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
        
        let width = CGFloat(200)
        let height = CGFloat(50)
        let padding = CGFloat(50)
        var currY = self.view.frame.height / 2
        let x = (self.view.frame.width - width) / 2
        
        self.locButton = UIButton()
        self.locButton.setTitle("LOCATION", for: UIControlState.normal)
        self.buttonArray.append(self.locButton)
        
        self.prefButton = UIButton()
        self.prefButton.setTitle("PREFERENCES", for: UIControlState.normal)
        self.buttonArray.append(self.prefButton)
        
        self.wheelButton = UIButton()
        self.wheelButton.setTitle("WHEEL", for: UIControlState.normal)
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
        self.navigationController?.pushViewController(self.viewsArray[sender.tag], animated: true)
    }
    
    func addDummyViews() {
        
        let dummyController1 = UIViewController()
        dummyController1.view.backgroundColor = UIColor.red
        self.viewsArray.append(dummyController1)
        
        let dummyController2 = UIViewController()
        dummyController2.view.backgroundColor = UIColor.white
        self.viewsArray.append(dummyController2)
        
        let dummyController3 = WheelViewController()
        //dummyController3.view.backgroundColor = UIColor.blue
        self.viewsArray.append(dummyController3)

    }
    
}
