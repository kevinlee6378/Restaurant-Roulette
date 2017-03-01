//
//  ViewController.swift
//  Restaurant-Roulette
//
//  Created by Kevin Lee on 2/22/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var position = 0.0
    var hasFinishedSpinning = true
    @IBOutlet weak var wheel: UIImageView!
    //var button = UIButton(frame: CGRect(x:100, y: 100, width: 70, height: 70))
    @IBOutlet weak var spinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let button = UIButton(frame: CGRect(x:0, y: 0, width: 70, height: 70))
        //button.center = self.view.center
        print(self.view.center.x.description + " " + self.view.center.y.description)
        
        //button.backgroundColor = .green
        //button.setTitle("spinner", for: .normal)
        //button.addTarget(self, action: #selector(spin2), for: .touchUpInside)
        //self.view.addSubview(button)
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
    //func spin2(sender: UIButton!){
        //button.backgroundColor = .yellow
    //    print("hello")
   // }
    
    @IBAction func spin(_ sender: Any) {
        if (hasFinishedSpinning){
            hasFinishedSpinning = false
            let spinResult = M_PI*4*(Double(arc4random())/0xFFFFFFFF) + M_PI*2
            let spinAnimation = CABasicAnimation()
            spinAnimation.fromValue = position
            spinAnimation.toValue = spinResult
            spinAnimation.duration = 5
            spinAnimation.repeatCount = 0
            spinAnimation.isRemovedOnCompletion = false
            spinAnimation.fillMode = kCAFillModeForwards
            spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            wheel.layer.add(spinAnimation, forKey: "transform.rotation.z")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                self.position = spinResult.truncatingRemainder(dividingBy: M_PI*2)
                self.hasFinishedSpinning = true
                print(self.position)
            }
            
        }

    }
/*
    @IBAction func spin(_ sender: Any) {
        position = (position + 700)%360
        UIView.animate(withDuration: 1.0, animations: {
            self.wheel.transform = CGAffineTransform(rotationAngle: CGFloat(self.position))
        })
        
    }
 */
    

}

