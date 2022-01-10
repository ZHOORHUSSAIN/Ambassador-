//
//  LocationViewController.swift
//  Ambassador
//
//  Created by زهور حسين on 29/05/1443 AH.
//

import UIKit
import CoreLocation
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

class LocationViewController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var latitudelable: UILabel!
    
    
    @IBOutlet weak var longitudelable: UILabel!
    
    
    @IBOutlet weak var addresslable: UILabel!
    
    
    var locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var DetectLocationButton: UIButton!{
        didSet {
    DetectLocationButton.setTitle("Detect Location".localized, for: .normal)
        }
    }
    
    
    @IBOutlet weak var Askme: UILabel!{
        didSet {
            Askme.text = "Ask me".localized
            
            Askme.layer.masksToBounds = true
            Askme.layer.cornerRadius = 4
        }
    }
    
    
    
    @IBOutlet weak var HealthPassportlable: UILabel!{
        didSet {
            HealthPassportlable.text = "Health Passport".localized
            
            
            HealthPassportlable.layer.masksToBounds = true
            HealthPassportlable.layer.cornerRadius = 4
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // init location manager
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//
         locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
    }
    
    
    
    @IBAction func detectLocation(_ sender: Any) {
        //configure location manager
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//
//        //check if location/gps eabled or not
//        if CLLocationManager.locationServicesEnabled() {
//            //location enable
//            print("Location Enabled")
//            locationManager.startUpdatingLocation()
//
//        }
//        else{
//            //location not enabled
//            print("Location Not Enabled")
//        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //get current location
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
                let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    self.addresslable.text = "\(city + ", " + country)"
                    self.latitudelable.text = "Latityde: \(locValue.latitude)"
                    self.longitudelable.text = "Longitude: \(locValue.longitude)"
                    
                }
//
//        let userLocation = locations[0] as CLLocation
//
//        //get current, longitude
//
//        let latitude = userLocation.coordinate.latitude
//        let longitude = userLocation.coordinate.longitude
//
//        //set to UI Lables
//        latitudelable.text = "Latityde: \(latitude)"
//        longitudelable.text = "Longitude: \(longitude)"
//
//        //get address
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation){ (placemarks,error) in
//            if (error != nil){
//                print("Erooro in reverseGeocodeLocation")
//    }
//        let placemark = placemarks! as [CLPlacemark]
//            if (placemark.count>0){
//                let placemark = placemarks![0]
//
//                let locality = placemark.locality ?? ""
//                let administrativeArea = placemark.administrativeArea ?? ""
//                let country = placemark.country ?? ""
//                print("!!!!!!locality")
//
//                //set to address UI label
//                self.addresslable.text = "Address:\(locality), \(administrativeArea), \(country)"
//}
//        }
    }
}
