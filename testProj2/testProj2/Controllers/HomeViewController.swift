//
//  HomeViewController.swift
//  testProj2
//
//  Created by tp on 11/03/2019.
//  Copyright © 2019 imis. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class HomeViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabl: UILabel!
    @IBOutlet weak var weatherStatusImView: UIImageView!
    @IBOutlet weak var villeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minMaxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var UVLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var multiInfoView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    var locationManager:CLLocationManager!
    var favorite: Bool! = false;
    var villeParam: String!;
    var villeRequete: String!{
        didSet {
            //Get ville infos
            print("villeset")
            if villeRequete != nil {
                getWsData(ville: villeRequete)
            }
        }
    };
    var weatherIconId : NSNumber = NSNumber()
    
    /*
     Reste à faire sur la page:
                                - bouton fav
                                - images du temps actuel
                                - adapter la ville de la météo (mettre en param) + mettre la vraie api key
                                - convertir degres du vent en direction
                                - dl les icones du site et les renommer
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        
        
        let dateAjd = Date() // Récupération de la date d'aujourd'hui
        let formatter = DateFormatter()
        
       // getWsData(ville: "Orleans")
       // getUVfromWS()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newYork0.jpg")!)
        weatherStatusImView.image = UIImage(named: self.getIconFromId(id_temps: weatherIconId.intValue) )
        multiInfoView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMM yyyy" // Formatage français de la date
        dateLabl.text = formatter.string(from: dateAjd).capitalized
    }
    
    
    /**
     Récupère les données du webservice.
     */
    func getWsData(ville: String){
        print(ville)
        let url : String = "https://api.openweathermap.org/data/2.5/weather?q="+ville+"&appid=0fe58b4b34de9e8260b69024f643a82a"
        var rep : [String : Any] = [String : Any]()
        Alamofire.request(url).responseJSON{ (reponse) in

             if(reponse.result.isSuccess){
                rep = (reponse.result.value! as? [String : Any])!
                self.initilizeComponentsFromData(data: rep) // On est obligé d'initialiser les composant ici car l'appel au ws prend du temps et donc certains composants sont vides
             }else{
                print("Erreur : \(reponse.result.error!)")
             }
        }
    }
    
    func getUVfromWS(lat: NSNumber, lng: NSNumber){
        let lat_string = String(lat.doubleValue)
        let lng_string = String(lng.doubleValue)
        
        let url = "https://api.openweathermap.org/data/2.5/uvi?lat="+lat_string+"&lon="+lng_string+"&appid=0fe58b4b34de9e8260b69024f643a82a"
        var rep : [String : Any] = [String : Any]()
        Alamofire.request(url).responseJSON{ (reponse) in
            if(reponse.result.isSuccess){
                rep = (reponse.result.value! as? [String : Any])!
                let uvIndex : NSNumber = rep["value"] as! NSNumber
                self.UVLabel.text = "Indice UV \n" + String(uvIndex.floatValue)
            }else{
                print("Erreur : \(reponse.result.error!)")
            }
        }
    }
    
    
    /**
     Initialise les composants de la vue à partir des données récupérées du webservice.
     
     - Parameter data: Les données du webservice.
     */
    func initilizeComponentsFromData(data : [String : Any] ){
        let main : [String : AnyObject] = data["main"] as! [String : AnyObject]
        let windData = data["wind"] as! [String : AnyObject]
        let coord = data["coord"] as! [String : AnyObject]
        let weatherArray = data["weather"] as! [[String: AnyObject]]
        let weather = weatherArray[0]
        self.weatherIconId = weather["id"] as! NSNumber
        let min : NSNumber = main["temp_min"] as! NSNumber
        let max : NSNumber = main["temp_max"] as! NSNumber
        let humidity : NSNumber = main["humidity"] as! NSNumber
        let windSpeed : NSNumber = windData["speed"] as! NSNumber
        let windDirection : NSNumber = windData["deg"] as! NSNumber
        let lat : NSNumber = coord["lat"] as! NSNumber
        let lng : NSNumber = coord["lon"] as! NSNumber
        
        villeLabel.text = (data["name"] as! String).capitalized
        tempLabel.text = String((main["temp"] as! NSNumber).intValue) + "°C"
        minMaxLabel.text = String(min.intValue) + "°C /" + String(max.intValue) + "°C"
        humidityLabel.text = "Humidité \n" + String(humidity.intValue) + "%"
        windDirectionLabel.text = "Dir-Vent \n" + String(windDirection.intValue)
        windSpeedLabel.text = "Vitesse \n" + String(windSpeed.intValue) + " km/h"
        
        getUVfromWS(lat: lat, lng: lng);
        
        print(villeLabel.text)

    }
    
    
    @IBAction func onFavorite(_ sender: Any) {
        if villeRequete != nil {        UserDefaults.standard.set(villeRequete, forKey: "favorite");
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
    
    func getIconFromId(id_temps: Int) -> String {
        switch (id_temps) {
            case 0...300 :
                return "tstorm1"
            
            case 301...500 :
                return "light_rain"
            
            case 501...600 :
                return "shower3"
            
            case 601...700 :
                return "snow4"
            
            case 701...771 :
                return "fog"
            
            case 772...799 :
                return "tstorm3"
            
            case 800 :
                return "sunny"
            
            case 801...804 :
                return "cloudy2"
            
            case 900...903, 905...1000  :
                return "tstorm3"
            
            case 903 :
                return "snow5"
            
            case 904 :
                return "sunny"
            
            default :
                return "chi_pas"
        }
    }
    
    /**
     Creates a personalized greeting for a recipient.
     
     - Parameter recipient: The person being greeted.
     
     - Throws: `MyError.invalidRecipient`
     if `recipient` is "Derek"
     (he knows what he did).
     
     - Returns: A new string saying hello to `recipient`.
     */
}
