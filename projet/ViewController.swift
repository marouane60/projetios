//
//  ViewController.swift
//  projet
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 projet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var maxTemp: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    var locationManager:CLLocationManager!
    var favorite: Bool! = false;
    var villeParam: String!;
    var villeRequete: String!{
        didSet {
            //Get ville infos
            print("villeset")
            if villeRequete != nil {
                Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=" + villeRequete + "&APPID=0fe58b4b34de9e8260b69024f643a82a").validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        let json = JSON(response.result.value!)
                        
                        print(json["name"])
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    };
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    
        
        if(villeParam != nil){
            
            villeRequete = villeParam;
            
        }else{
            let favorite =  UserDefaults.standard.string(forKey: "favorite")
            
            if(favorite != nil){
                
                villeRequete = favorite;
                
            }else{
                if CLLocationManager.locationServicesEnabled(){
                    locationManager.startUpdatingLocation()
                }
            }
            
        }
        
        
    

        
    }
    
    // https://stackoverflow.com/questions/25296691/get-users-current-location-coordinates
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0];
                let locality = placemark.locality!;
                let localityFormatted = locality.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "é", with: "e")
                self.villeRequete = localityFormatted;
                
            }
        }
        
    }
    
    // Onclick on the Settings button
    @IBAction func onSetting(_ sender: Any) {
        
    }
    
    // Onclick on the favorite button
    @IBAction func onFavorite(_ sender: Any) {
        if villeRequete != nil {        UserDefaults.standard.set(villeRequete, forKey: "favorite");
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}

