//
//  LocationViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 29/05/1443 AH.
//

import UIKit
import CoreLocation
class LocationViewController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var latitudelable: UILabel!
    
    
    @IBOutlet weak var longitudelable: UILabel!
    
    
    @IBOutlet weak var addresslable: UILabel!
    
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // init location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
    }
    
    
    
    @IBAction func detectLocation(_ sender: Any) {
        //configure location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        //check if location/gps eabled or not
        if CLLocationManager.locationServicesEnabled() {
            //location enable
            print("Location Enabled")
            locationManager.startUpdatingLocation()
        }
        else{
            //location not enabled
            print("Location Not Enabled")
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get current location
        
        let userLocation = locations[0] as CLLocation
        
        //get current, longitude
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        //set to UI Lables
        latitudelable.text = "Latityde: \(latitude)"
        longitudelable.text = "Longitude: \(longitude)"
        
        //get address
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation){ (placemarks,error) in
            if (error != nil){
                print("Erooro in reverseGeocodeLocation")
    }
        let placemark = placemarks! as [CLPlacemark]
            if (placemark.count>0){
                let placemark = placemarks![0]
                
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                
                //set to address UI label
                self.addresslable.text = "Address:\(locality), \(administrativeArea), \(country)"
}
        }
    }
}
