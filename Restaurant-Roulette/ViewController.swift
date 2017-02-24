//
//  ViewController.swift
//  Restaurant-Roulette
//
//  Created by Kevin Lee on 2/22/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var position = 0;
    @IBOutlet weak var wheel: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func spin(_ sender: Any) {
        position = (position + 700)%360
        UIView.animate(withDuration: 1.0, animations: {
            self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(self.position))
        })
        
    }

}

