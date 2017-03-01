//
//  ViewController.swift
//  Restaurant-Roulette
//
//  Created by Kevin Lee on 2/22/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var chosen: UITextField!
    var options = ["1", "2", "3", "4"]
    var position = 0.0
    var hasFinishedSpinning = true
    @IBOutlet weak var wheel: UIImageView!
    @IBOutlet weak var spinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.center.x.description + " " + self.view.center.y.description)
        wheel.image = textToImage(drawText: "1", inImage: wheel.image!, atPoint: CGPoint(x: 195, y:75))
        wheel.image = textToImage(drawText: "3", inImage: wheel.image!, atPoint: CGPoint(x: 195, y: 320))
        wheel.image = textToImage(drawText: "4", inImage: wheel.image!, atPoint: CGPoint(x: 72.5, y: 197.5))
        wheel.image = textToImage(drawText: "2", inImage: wheel.image!, atPoint: CGPoint(x: 317.5, y: 197.5))
        wheel.center = self.view.center
        spinButton.center = self.view.center
        spinButton.layer.cornerRadius = 35
    }

    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func spin(_ sender: Any) {
        if (hasFinishedSpinning){
            hasFinishedSpinning = false
            var spinResult = M_PI*4*(Double(arc4random())/0xFFFFFFFF) + M_PI*2
            if ((spinResult - position) < M_PI*2){
                spinResult += M_PI*2
            }
            let spinAnimation = CABasicAnimation()
            spinAnimation.fromValue = position
            spinAnimation.toValue = spinResult
            spinAnimation.duration = 5
            spinAnimation.repeatCount = 0
            spinAnimation.isAdditive = true
            spinAnimation.isRemovedOnCompletion = false
            spinAnimation.fillMode = kCAFillModeForwards
            spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            wheel.layer.add(spinAnimation, forKey: "transform.rotation.z")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                self.position = spinResult.truncatingRemainder(dividingBy: M_PI*2)
                self.hasFinishedSpinning = true
                print(self.position/M_PI)
                self.chosen.text = self.chooseBasedOnPosition(atPosition: self.position)
            }
            
        }

    }
    func chooseBasedOnPosition(atPosition pos: Double) -> String{
        if (pos <= M_PI_4 || pos > 7*M_PI_4){
            return options[0]
        }
        else if (pos <= 3*M_PI_4 && pos > M_PI_4) {
            return options[3]
        }
        else if (pos <= 5*M_PI_4 && pos > 3*M_PI_4){
            return options[2]
        }
        else {
            return options[1]
        }
    }
}

