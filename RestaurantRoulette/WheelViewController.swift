//
//  ViewController.swift
//  Restaurant-Roulette
//
//  Created by Kevin Lee on 2/22/17.
//  Copyright © 2017 Kevin Lee. All rights reserved.
//

import UIKit
import CoreLocation

class WheelViewController: UIViewController {
    
    //var hasSearched = false
    // var locationManager = CLLocationManager()
    var directionModifier = 1.0
    var latitude: String = ""
    var longitude: String = ""
    var searchRadius = 0
    var minRating = 0
    var prices: [Bool] = []
    var type = ""
    let accessToken = "cvpQEJX1h215Y9TKBauwapUB1FeMVW_KdmO-NOaXYZ0liusAnXlYYGlmnPZknmODwTxi9cdduq_6lH--VxBV34dh5L3DQUuUbIJlAyWSieblnnY1WGxCHfqbTfzTWHYx"
    var baseView: UIView!
    var myCustomView: UIView!
    var buttonArray: [UIButton] = []
    var chosen: UITextView!
    var options: [(String, String)] = [("", ""), ("", ""), ("", ""), ("", "")]
    let rect1 = CGRect(x: 195, y: 75, width: 150, height: 100)
    var position = 0.0
    var option = ""
    var optionIndex = 0
    var hasFinishedSpinning = true
    var wheel: UIImageView!
    var spinButton: UIButton!
    
    var logoImgUrl = ["","","",""]
    var websiteUrl = ["","","",""]
    var logoImg = ""
    var weburl = ""
    
    var wheelSize: Int = 0
    var wheelHalfSize: Int = 0
    var wheelQuarterSize: Int = 0
    
    
    var businessesArray: [JSON] = []
    var usedRestaurants: [String: Bool] = [:]
    
    var optionLabels: [UILabel] = [UILabel(), UILabel(), UILabel(), UILabel()]
    
    var wedges = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeSearch(latitude: self.latitude, longitude: self.longitude, radius: self.searchRadius, prices: self.prices, rating: self.minRating)
        setupWheel()
        setupSpinBUtton()
        setupChosen()
        
        wheel.isHidden = true
        spinButton.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshRestaurants))
        /*
         //request for authorization
         //self.locationManager.requestAlwaysAuthorization()
         self.locationManager.requestWhenInUseAuthorization()
         
         //start updating location once authorized
         
         if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
         locationManager.startUpdatingLocation()
         }
         
         */
        //getAccessToken()
        //makeSearch(latitude: self.latitude, longitude: self.longitude)
        wheel.isUserInteractionEnabled = true
        chosen.textAlignment = .center
        
        //loadWheelButtons()
        //loadWheelOptions()
        spinButton.layer.cornerRadius = CGFloat(Int(Double(self.wheelQuarterSize)/2.0))
        //print(self.view.center.x.description + " " + self.view.center.y.description)
        //let button = UIButton(frame: rect1)
        //let x = self.view.center.x
        //let y = self.view.center.y - 90
        //button.center = CGPoint(x: x, y: y)
        //button.backgroundColor = .black
        //button.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        //self.view.addSubview(button)
        
        //let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector(("rightSwiped")))
        //swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        makeSearch(latitude: self.latitude, longitude: self.longitude, radius: self.searchRadius, prices: self.prices, rating: self.minRating)
        hideWedges()
    }
    
    func refreshRestaurants() {
        makeSearch(latitude: self.latitude, longitude: self.longitude, radius: self.searchRadius, prices: self.prices, rating: self.minRating)
        hideWedges()
    }
    
    func rightSwiped() {
        print("Swiped Right!")
    }
    
    func setupWheel() {
        
        self.wheelSize = Int(self.view.frame.width -  50)
        self.wheelHalfSize = self.wheelSize / 2
        self.wheelQuarterSize = self.wheelSize / 4
        
        self.wheel = UIImageView()
        self.wheel.isUserInteractionEnabled = true
        self.wheel.image = UIImage(named: "wheel1")
        //let width = CGFloat(400)
        //let height = CGFloat(400)
        let width = self.wheelSize
        let height = self.wheelSize
        let x = (Int(self.view.frame.width) - width) / 2
        let y = (Int(self.view.frame.height) - height) / 2
        self.wheel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.wheel.contentMode = .scaleAspectFit
        //let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        //self.wheel.addGestureRecognizer(panGesture)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.wheel.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.wheel.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        self.view.addSubview(self.wheel)

        
        
        var wedge = UIImage(named: "wedge2")
        var positions: [[Int]] = [[0, 0], [self.wheelHalfSize, 0], [self.wheelHalfSize, self.wheelHalfSize], [0, self.wheelHalfSize]]
        
        for index in 0...3 {
            var wedgeView = UIImageView()
            let wedgeWidth = self.wheelHalfSize
            let wedgeHeight = self.wheelHalfSize
            let wedgeX = positions[index][0]
            let wedgeY = positions[index][1]
            wedgeView.frame = CGRect(x: wedgeX, y: wedgeY, width: wedgeWidth, height: wedgeHeight)
            wedgeView.image = wedge
            wedgeView.transform = wedgeView.transform.rotated(by: CGFloat(M_PI_2 * Double(index)))
            self.wedges.append(wedgeView)
            wedgeView.isHidden = true
            self.wheel.addSubview(wedgeView)
            
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            let location = swipeGesture.location(in: self.view)
            print(location.x.description + " " + location.y.description)
            let midY = self.wheel.frame.origin.y + self.wheel.frame.height/2
            let midX = self.wheel.frame.origin.x + self.wheel.frame.width/2

            //let yLength = self.wheel.frame.maxY-self.wheel.frame.minY
            //let xLength = self.wheel.frame.maxX-self.wheel.frame.minX
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if (location.y < midY){
                    self.directionModifier = 1.0
                }
                else {
                    self.directionModifier = -1.0
                    print("got here")
                }
                self.spin()
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                if (location.x < midX){
                    self.directionModifier = -1.0
                }
                else {
                    self.directionModifier = 1.0
                }
                self.spin()
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                if (location.y < midY){
                    self.directionModifier = -1.0
                }
                else {
                    self.directionModifier = 1.0
                    print("ds")
                }
                self.spin()
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                if (location.x < midX){
                    self.directionModifier = 1.0
                }
                else {
                    self.directionModifier = -1.0
                }
                self.spin()
                print("Swiped up")
            default:
                break
            }
        }
    }
    func handlePanGesture(panGesture: UIPanGestureRecognizer){
        //let gestureTranslation = panGesture.translation(in: self.view)
        //var start: CGPoint = panGesture.location(in: self.view)
        //var end: CGPoint
        //let gestureVelocity = panGesture.velocity(in: self.wheel)
        var start = 0.0
        var end = 0.0
        var time = 0.0
        var speed = 0.0
        if panGesture.state == UIGestureRecognizerState.began {
            // add something you want to happen when the Label Panning has started
            //print("start")
            start = CFAbsoluteTimeGetCurrent()
            //start = panGesture.location(in: self.view)
        }
        
        if panGesture.state == UIGestureRecognizerState.ended {
            // add something you want to happen when the Label Panning has ended
            //end = panGesture.location(in: self.view)
            end = CFAbsoluteTimeGetCurrent()
            time = end - start
            //print("end " + String(time))
            //print(start.x.description + " " + start.y.description)
            //print(end.x.description + " " + end.y.description)
            //print("trans" + gestureTranslation.x.description + " " + gestureTranslation.y.description)
            //print("velocity" + gestureVelocity.x.description + " " + gestureVelocity.y.description)
        }
    }
    
    func setupSpinBUtton() {
        self.spinButton = UIButton()
        self.spinButton.setTitle("SPIN", for: UIControlState.normal)
        let width = CGFloat(self.wheelHalfSize / 2)
        let height = CGFloat(self.wheelHalfSize / 2)
        let xPos = (self.view.frame.width - width) / 2
        let yPos = (self.view.frame.height - height) / 2
        self.spinButton.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        self.spinButton.backgroundColor = UIColor.black
        self.spinButton.addTarget(self, action: #selector(spin), for: .touchUpInside)
        self.view.addSubview(self.spinButton)
    }
    
    func setupChosen() {
        self.chosen = UITextView()
        let width = CGFloat(200)
        let height = CGFloat(100)
        let x = (self.view.frame.width - width) / 2
        let y = (self.view.frame.height - height) / 2
        self.chosen.frame = CGRect(x: x, y: y - 500, width: width, height: height)
        self.chosen.textColor = UIColor.black
        self.view.addSubview(self.chosen)
    }
    
    func loadWheelOptions() {
        for view in self.wheel.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
        
        textToImage(index: 0, drawText: options[0].1 as NSString , inImage: wheel, atPoint: CGPoint(x: self.wheelHalfSize - self.wheelQuarterSize, y: self.wheelHalfSize - self.wheelQuarterSize), withAngle: CGFloat(M_PI_4 * Double(7)))
        textToImage(index: 1, drawText: options[1].1 as NSString, inImage: wheel, atPoint: CGPoint(x: self.wheelHalfSize + self.wheelQuarterSize, y: self.wheelHalfSize - self.wheelQuarterSize), withAngle:
            CGFloat(M_PI_4))
        textToImage(index: 2, drawText: options[2].1 as NSString, inImage: wheel, atPoint: CGPoint(x: self.wheelHalfSize + self.wheelQuarterSize, y: self.wheelHalfSize + self.wheelQuarterSize), withAngle:
            CGFloat(M_PI_4 * Double(3)))
        textToImage(index: 3, drawText: options[3].1 as NSString, inImage: wheel, atPoint: CGPoint(x: self.wheelHalfSize - self.wheelQuarterSize, y: self.wheelHalfSize + self.wheelQuarterSize), withAngle:
            CGFloat(M_PI_4 * Double(5)))
        
    }
    
    func shuffle(originalArray: Array<Any>) -> Array<Any> {
        var result = originalArray
        result.indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(result.count - $0))) + $0, index != $0 else { return }
            swap(&result[$0], &result[index])
        }
        return result
    }
    
    //    func loadWheelButtons() {
    //        let shiftx = 90.0
    //        let shifty = 110.0
    //        let button1 = UIButton(frame: CGRect(x:195 - shiftx, y: 75 - shifty + 50, width:120, height:50))
    //        button1.setTitle(options[0], for: .normal)
    //        button1.backgroundColor = .black
    //        button1.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
    //        buttonArray.append(button1)
    //        let button4 = UIButton(frame: CGRect(x:317.5 - shiftx, y: 197.5 - shifty, width:60, height:100))
    //        button4.setTitle(options[1], for: .normal)
    //
    //        button4.backgroundColor = .blue
    //        button4.addTarget(self, action: #selector(showDetails2), for: .touchUpInside)
    //
    //        buttonArray.append(button4)
    //        let button2 = UIButton(frame: CGRect(x:195 - shiftx, y: 320 - shifty, width:120, height:50))
    //        button2.backgroundColor = .yellow
    //        button2.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
    //
    //        button2.setTitle(options[2], for: .normal)
    //
    //        buttonArray.append(button2)
    //        let button3 = UIButton(frame: CGRect(x:72.5 - shiftx + 60, y: 197.5 - shifty, width:60, height:100))
    //        button3.backgroundColor = .red
    //        button3.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
    //        button3.setTitle(options[3], for: .normal)
    //
    //        buttonArray.append(button3)
    //
    //        for button in buttonArray{
    //            wheel.addSubview(button)
    //        }
    //        hideButtons()
    //
    //    }
    func loadCustomViewIntoController()
    {
        let xstart = self.view.center.x/4
        let ystart = self.view.center.y/2
        let width = self.view.frame.width - 2*xstart
        let height = self.view.frame.height - 2*ystart + 200
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
            //print("Show Details")
            showPopUp()
            //loadCustomViewIntoController()
        }
    }
    
    /*func showDetails2(sender: UIButton!){
     if(hasFinishedSpinning){
     print("Show Details")
     loadCustomViewIntoController()
     }
     }*/
    
    func textToImage(index: Int, drawText text: NSString, inImage imageView: UIImageView, atPoint point: CGPoint, withAngle angle: CGFloat) {
        let textView = UILabel()
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.numberOfLines = 3
        textView.text = text as String
        textView.frame = CGRect(x: Int(point.x) - self.wheelQuarterSize, y: Int(point.y) - self.wheelQuarterSize, width: self.wheelHalfSize, height: self.wheelHalfSize)
        //print(textView.frame)
        //var transform = CGAffineTransform(translationX: 150, y: 92)
        var transform = CGAffineTransform(rotationAngle:angle)
        textView.transform = transform
        imageView.addSubview(textView)
        
        //        let textColor = UIColor.white
        //        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        //
        //        let scale = UIScreen.main.scale
        //        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        //
        //        let textFontAttributes = [
        //            NSFontAttributeName: textFont,
        //            NSForegroundColorAttributeName: textColor,
        //            ] as [String : Any]
        //        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        //
        //        let rect = CGRect(origin: point, size: image.size)
        //        text.draw(in: rect, withAttributes: textFontAttributes)
        //
        //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //
        //        return newImage!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func spin() {
        if (hasFinishedSpinning){
            //hideButtons()
            hideWedges()
            hasFinishedSpinning = false
            var spinResultTemp = (M_PI*4*(Double(arc4random())/0xFFFFFFFF) + M_PI*2)*3
            var spinResult = spinResultTemp * directionModifier
            //var spinResult = -8*M_PI + 3*M_PI/7
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
                if (self.position < 0){
                    self.position = self.position + 2*M_PI
                }
                self.option = self.chooseBasedOnPosition(atPosition: self.position)
                self.logoImg = self.chooseImgBasedOnPosition(atPosition: self.position)
                self.weburl = self.chooseWebURLBasedOnPosition(atPosition: self.position)
                self.hasFinishedSpinning = true
                print(self.position/M_PI)
                self.chosen.text = self.option
                self.optionIndex = self.chooseIndexBasedOnPosition(atPosition: self.position)
                //self.buttonArray[self.optionIndex].isHidden = false
                print(self.optionIndex)
                print(self.options[self.optionIndex])
                self.usedRestaurants[self.options[self.optionIndex].1] = true
                self.wedges[self.optionIndex].isHidden = false
                self.showPopUp()
            }
            
        }
        
    }
    func hideButtons() {
        for button in self.buttonArray{
            button.isHidden = true
        }
    }
    func hideWedges() {
        for wedge in self.wedges {
            wedge.isHidden = true
        }
    }
    func chooseIndexBasedOnPosition(atPosition pos: Double) -> Int {
        if (pos <  M_PI_2){
            return 0
        }
        else if (pos <  M_PI_2 * 2) {
            return 3
        }
        else if (pos < M_PI_2 * 3){
            return 2
        }
        else {
            return 1
        }
    }
    func chooseBasedOnPosition(atPosition pos: Double) -> String{
        return options[chooseIndexBasedOnPosition(atPosition: pos)].1
    }
    
    func chooseImgBasedOnPosition(atPosition pos: Double) -> String {
        return logoImgUrl[chooseIndexBasedOnPosition(atPosition: pos)]
    }
    
    func chooseWebURLBasedOnPosition(atPosition pos: Double) -> String {
        return websiteUrl[chooseIndexBasedOnPosition(atPosition: pos)]
    }
    
    
    func makeSearch(latitude: String, longitude: String, radius: Int, prices: [Bool], rating: Int) {
        var U = "https://api.yelp.com/v3/businesses/search?term="
        var typeQuery = ""
        if (type == "All Restaurants"){
            typeQuery = "restaurants"
        }
        else {
            typeQuery = type
        }
        U += typeQuery
        U += "&latitude="
        U += latitude
        U += "&longitude="
        U += longitude
        U += "&limit=20"
        U += "&radius="
        U += String(radius - 234)
        print(U)
        U += "&price="
        var hasSetFirst = false
        var priceQuery = ""
        for index in 0...3{
            if !hasSetFirst {
                if prices[index] {
                    priceQuery.append(String(index+1))
                    hasSetFirst = true
                }
            }
            else {
                if prices[index] {
                    priceQuery.append("," + String(index+1))
                }
            }
        }
        U += priceQuery
        print(U)
        var request = URLRequest(url: URL(string: U)!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                
                
                if(data != nil){
                    let responseString = String(data: data!, encoding: .utf8)
                    //print("responseString = \(responseString!)")
                    let jsonResult: JSON = JSON(data: data!)
                    let businesses : [JSON] = jsonResult["businesses"].array!
                    self.businessesArray = businesses
                    self.businessesArray = self.shuffle(originalArray: self.businessesArray) as! [JSON]
                    var i = 0
                    for business in self.businessesArray {
                        //print(business["name"].stringValue)
                        if i < 4 {
                            if (business["rating"].doubleValue >= Double(self.minRating) && self.usedRestaurants[business["id"].stringValue] == nil){
                                self.options[i] = (business["id"].stringValue, business["name"].stringValue)
                                self.logoImgUrl[i] = business["image_url"].stringValue
                                self.websiteUrl[i] = business["id"].stringValue
                                i = i + 1
                            }
                        }
                    }
                    self.loadWheelOptions()
                    //self.loadWheelButtons()
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
    
    func getframeheight() -> CGFloat {
        return view.frame.size.height
    }
    
    func getframewidth() -> CGFloat {
        return view.frame.size.width
    }
    
    
    var popViewController : PopUpViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    func showPopUp() {
        let bundle = Bundle(for: PopUpViewController.self)
        self.popViewController = PopUpViewController(nibName: "PopUpViewController", bundle: bundle, frame: self.view.frame)
        self.popViewController.title = "This is a popup view"
        self.popViewController.showInView(self.view, withImage: logoImg, withMessage: option, withURL: weburl, animated: true)
    }
    
}


