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


struct GlobalCoord {
    static var globalLong:String = "";
    static var globalLat:String = "";
}

let myStruct = GlobalCoord()

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var bestToilet: UIButton!

    @IBOutlet weak var closestToilet: UIButton!
    
    @IBAction func tButton (sender: UIButton!) {
        var ratingViewController: AnyObject? = self.storyboard?.instantiateViewControllerWithIdentifier("RatingView")
        
        self.presentViewController(ratingViewController as! UIViewController, animated: true, completion: nil)
        
        updateMap();
    }
    
    var mapView: GMSMapView!
    
    var current: GMSCameraPosition!
    
    var state: Bool!
    
    var locationMarker: GMSMarker!
    
    var globalJson: JSON!
    
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
    
    func updateMap(){
        state = false;
    }
    
    override func viewDidLoad() {
    
        
        
        println("TEST");
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = 1.0;
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.startUpdatingLocation()
        
        updateMap();
    
        mapView = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height/1.35))
        mapView.myLocationEnabled = true
        
        self.view.addSubview(mapView)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("got locations...")
        var latitude: CLLocationDegrees!
        var long: CLLocationDegrees!
        for thisLocation in locations{
            
            //get current location
            var currents = manager.location
            latitude = thisLocation.coordinate.latitude
            long = thisLocation.coordinate.longitude
            
            println("location is \(latitude), \(long)")
            
            GlobalCoord.globalLong = "\(thisLocation.coordinate.latitude)"
            GlobalCoord.globalLat = "\(thisLocation.coordinate.longitude)"
            
            current = GMSCameraPosition.cameraWithLatitude(latitude, longitude: long, zoom: 20)
            
            mapView.camera = current
            

            //Only needs to be done once
            locationMarker = GMSMarker(position: thisLocation.coordinate)
            locationMarker.title = "shitdicks"
            locationMarker.appearAnimation = kGMSMarkerAnimationPop
            locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
            locationMarker.map = mapView;
            
            
            
            
        }
        
        
        
        if state == false{
        

            
            //Iterate through all objects
            if (globalJson != nil){
                for (var i = 0; i < 1; i++){
                    //Gets latitude and long
                    var latitude = globalJson[i]["lat"];
                    var longitude = globalJson[i]["lon"];
                    
                    println((latitude).doubleValue)
                    println(longitude.doubleValue)
                    
                    let coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
                    println("Coordinate placed!");
                    
                    //Places a marker on the top
                        

                
                    

                    
            
                    
                    }
                    state = true;
            }
            
            //Returns coordinates
            getServer();
            
            
        }
        
    }
    

    
    func getServer() {
        let url = NSURL(string: "http://104.131.104.27:3000/get")
        var finCoor: CLLocationCoordinate2D!
        
        let tasks = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            self.globalJson = JSON(data: data)
            
        }
        tasks.resume()
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("ERROR with location: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

