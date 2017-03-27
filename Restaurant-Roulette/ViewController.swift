//
//  ViewController.swift
//  Restaurant-Roulette
//
//  Created by Kevin Lee on 2/22/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var hasSearched = false
    var locationManager = CLLocationManager()
    var latitude: String = ""
    var longitude: String = ""
    let accessToken = "cvpQEJX1h215Y9TKBauwapUB1FeMVW_KdmO-NOaXYZ0liusAnXlYYGlmnPZknmODwTxi9cdduq_6lH--VxBV34dh5L3DQUuUbIJlAyWSieblnnY1WGxCHfqbTfzTWHYx"
    var baseView: UIView!
    var myCustomView: UIView!
    var buttonArray: [UIButton] = []
    @IBOutlet weak var chosen: UITextField!
    var options = ["1", "2", "3", "4"]
    let rect1 = CGRect(x: 195, y: 75, width: 150, height: 100)
    var position = 0.0
    var option = ""
    var optionIndex = 0
    var hasFinishedSpinning = true
    @IBOutlet weak var wheel: UIImageView!
    @IBOutlet weak var spinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        wheel.isHidden = true
        spinButton.isHidden = true
        
        
        //request for authorization
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        //start updating location once authorized
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //getAccessToken()
        //makeSearch(latitude: self.latitude, longitude: self.longitude)
        wheel.isUserInteractionEnabled = true
        chosen.textAlignment = .center
        
        //loadWheelButtons()
        //loadWheelOptions()
        spinButton.center = self.view.center
        spinButton.layer.cornerRadius = 35
        print(self.view.center.x.description + " " + self.view.center.y.description)
        let button = UIButton(frame: rect1)
        let x = self.view.center.x
        let y = self.view.center.y - 90
        button.center = CGPoint(x: x, y: y)
        //button.backgroundColor = .black
        button.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    
    func loadWheelOptions() {
        wheel.image = textToImage(drawText: options[0] as NSString, inImage: wheel.image!, atPoint: CGPoint(x: 195, y:75))
        wheel.image = textToImage(drawText: options[2] as NSString, inImage: wheel.image!, atPoint: CGPoint(x: 195, y: 320))
        wheel.image = textToImage(drawText: options[3] as NSString, inImage: wheel.image!, atPoint: CGPoint(x: 72.5, y: 197.5))
        wheel.image = textToImage(drawText: options[1] as NSString, inImage: wheel.image!, atPoint: CGPoint(x: 317.5, y: 197.5))

        wheel.center = self.view.center
        
    }
    func loadWheelButtons() {
        let shiftx = 90.0
        let shifty = 110.0
        let button1 = UIButton(frame: CGRect(x:195 - shiftx, y: 75 - shifty + 50, width:120, height:50))
        button1.setTitle(options[0], for: .normal)
        button1.backgroundColor = .black
        button1.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        buttonArray.append(button1)
        let button4 = UIButton(frame: CGRect(x:317.5 - shiftx, y: 197.5 - shifty, width:60, height:100))
        button4.setTitle(options[1], for: .normal)
        
        button4.backgroundColor = .blue
        button4.addTarget(self, action: #selector(showDetails2), for: .touchUpInside)
        
        buttonArray.append(button4)
        let button2 = UIButton(frame: CGRect(x:195 - shiftx, y: 320 - shifty, width:120, height:50))
        button2.backgroundColor = .yellow
        button2.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        
        button2.setTitle(options[2], for: .normal)
        
        buttonArray.append(button2)
        let button3 = UIButton(frame: CGRect(x:72.5 - shiftx + 60, y: 197.5 - shifty, width:60, height:100))
        button3.backgroundColor = .red
        button3.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        button3.setTitle(options[3], for: .normal)
        
        buttonArray.append(button3)
        
        for button in buttonArray{
            wheel.addSubview(button)
        }
        hideButtons()

    }
    func loadCustomViewIntoController()
    {
        let xstart = self.view.center.x/4
        let ystart = self.view.center.y/2
        let width = self.view.frame.width - 2*xstart
        let height = self.view.frame.height - 2*ystart
        myCustomView = UIView(frame: CGRect(x: xstart, y: ystart, width: width, height: height))
        myCustomView.backgroundColor = .blue
        self.view.addSubview(myCustomView)
        
        myCustomView.isHidden = false
        
        let okayButton = UIButton(frame: CGRect(x: xstart, y: ystart + 100, width: 200, height: 50))
        okayButton.backgroundColor = .yellow
        okayButton.setTitle("Done", for: .normal)
        okayButton.setTitleColor(.black, for: .normal)
        myCustomView.addSubview(okayButton)
        
        let label = UILabel(frame: CGRect(x: xstart, y: ystart, width: 200, height: 50))
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "Details for option: " + option
        myCustomView.addSubview(label)
        
        okayButton.addTarget(self, action: #selector(self.okButtonImplementation), for:.touchUpInside)
        
    }
    
    
    func okButtonImplementation(sender:UIButton){
        myCustomView.isHidden = true
    }
    
    func showDetails(sender: UIButton!){
        if(hasFinishedSpinning){
            print("Show Details")
            loadCustomViewIntoController()
        }
    }
    func showDetails2(sender: UIButton!){
        if(hasFinishedSpinning){
            print("Show Details")
            loadCustomViewIntoController()
        }
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
            hideButtons()
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
                self.option = self.chooseBasedOnPosition(atPosition: self.position)
                self.hasFinishedSpinning = true
                print(self.position/M_PI)
                self.chosen.text = self.option
                self.optionIndex = self.chooseIndexBasedOnPosition(atPosition: self.position)
                self.buttonArray[self.optionIndex].isHidden = false
                print(self.optionIndex)
            }
            
        }

    }
    func hideButtons() {
        for button in self.buttonArray{
            button.isHidden = true
        }
    }
    func chooseIndexBasedOnPosition(atPosition pos: Double) -> Int {
        if (pos <= M_PI_4 || pos > 7*M_PI_4){
            return 0
        }
        else if (pos <= 3*M_PI_4 && pos > M_PI_4) {
            return 3
        }
        else if (pos <= 5*M_PI_4 && pos > 3*M_PI_4){
            return 2
        }
        else {
            return 1
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
    
    func makeSearch(latitude: String, longitude: String) {
        var U = "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude="
        U += latitude
        U += "&longitude="
        U += longitude
        U += "&limit=20"
        
        var request = URLRequest(url: URL(string: ("https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=38.6682&longitude=-90.3325&limit=20"))!)
        //var request = URLRequest(url: URL(string: U)!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                
            
            if(data != nil){
                //let responseString = String(data: data!, encoding: .utf8)
                //print("responseString = \(responseString!)")
                let jsonResult: JSON = JSON(data: data!)
                let businesses : [JSON] = jsonResult["businesses"].array!
                var i = 0
                for business in businesses {
                    print(business["name"].stringValue)
                    if i < 4 {
                    self.options[i] = business["name"].stringValue
                    i = i + 1
                    }
                }
                self.loadWheelOptions()
                self.loadWheelButtons()
                self.wheel.isHidden = false
                self.spinButton.isHidden = false
            }
            }
        })
        task.resume()
    }
    func getAccessToken() {
        let appID = "DRksLe3it7tL8VAQ6oL3tA"
        let appSecret = "Pc2Jd4Txagz6Sj5ETteAQX2H49FL1nvOGMzb1EM2BZn66A2Y13OrrLh4i9vyZNoD"
        var request = URLRequest(url: URL(string: "https://api.yelp.com/oauth2/token")!)
        request.httpMethod = "POST"
        var postString = "grant_type=client_credentials"
        postString += "&client_id=" + appID
        postString += "&client_secret=" + appSecret
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = String(locValue.latitude)
        self.longitude = String(locValue.longitude)
        if !hasSearched {
            self.makeSearch(latitude: self.latitude, longitude: self.longitude)
            hasSearched = true
        }

    }
    
}


