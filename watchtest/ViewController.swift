//
//  ViewController.swift
//  watchtest
//
//  Created by Numaer Zaker Dave Abelson on 9/4/15.
//
//  Copyright (c) 2015 D's Nuts. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var bestToilet: UIButton!

    @IBOutlet weak var closestToilet: UIButton!
    
    @IBAction func tButton (sender: UIButton!) {
        var ratingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RatingView")
        
        self.presentViewController(ratingViewController as! UIViewController, animated: true, completion: nil)
    }
    
    var mapView: GMSMapView!
    
    var current: GMSCameraPosition!
    
    var state: Bool!
    
    var locationMarker: GMSMarker!
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status:
        CLAuthorizationStatus) {
        println("Location Method called")
        doAuthorizationChecks()
    }
    
    func doAuthorizationChecks() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse {
            println("already authorized at launch")
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
                println("already authorized at always")
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            println("not determined status. requesting...")
            locationManager.requestWhenInUseAuthorization()
        }
        else{
            println("some other weird status from authorization status")
            println("some weird status \(CLLocationManager.authorizationStatus())" )
        }
        if CLLocationManager.locationServicesEnabled() {
            println("location services enabled")
        }
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        doAuthorizationChecks()
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.startUpdatingLocation()
        
        state = false;
    
        mapView = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height/1.35))
        mapView.myLocationEnabled = true
        
        self.view.addSubview(mapView)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("got locations...")
        var latitude: CLLocationDegrees!
        var long: CLLocationDegrees!
        for thisLocation in locations{
            latitude = thisLocation.coordinate.latitude
            long = thisLocation.coordinate.longitude
            
            println("location is \(latitude), \(long)")
            
        }
        if state == false{
        
            current = GMSCameraPosition.cameraWithLatitude(latitude, longitude: long, zoom: 16)

            mapView.camera = current
            
            state = true
        }
        
    }
    
    //Places a marker on the top
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView;
        locationMarker.title = "shitdicks"
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 0.75
    }
    
    func getServer() -> CLLocationCoordinate2D {
        let url = NSURL(string: "http://104.131.104.27:3000/")
        var finCoor: CLLocationCoordinate2D!
        
        let tasks = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            let json = JSON(data: data)
            if (json != nil) {
                //Gets the latitude value of first json
                var firstEle = json[0]["lat"]
                
                //Iterate through all objects
                for (var i = 0; i < json.count; i++){
                    //Gets latitude and long
                    var latitude = json[i]["lat"];
                    
                    var longitude = json[i]["lon"];
                    println((latitude).doubleValue)
                    println(longitude.doubleValue)
                    
                    /* Deal with error handling later cause i'm fkins tupid
                    if (((json[i]["lat"].string)) == nil){
                    
                    }
                    if (((json[i]["lon"].string)) != nil){
                    //Value of longitude is now defined
                    }
                    */
                    //CLLocationDegrees
                    let coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
                    finCoor = coordinate;
                    //self.setupLocationMarker(coordinate);
                    println("Coordinate placed!");
                    
                }
                println("SwiftyJSON: \(firstEle)")
            }
            else{
                println("swag swag");
            }
        }
        if (finCoor != nil){
            return finCoor
        }
        tasks.resume()
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("ERROR with location: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

