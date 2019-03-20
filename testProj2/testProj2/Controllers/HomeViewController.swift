//
//  HomeViewController.swift
//  testProj2
//
//  Created by tp on 11/03/2019.
//  Copyright © 2019 imis. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
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
        let dateAjd = Date() // Récupération de la date d'aujourd'hui
        let formatter = DateFormatter()
        
        getWsData(ville: "Orleans")
        getUVfromWS()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newYork0.jpg")!)
        weatherStatusImView.image = UIImage(named: /*self.getIconFromId(id_temps: weatherIconId.intValue) + */ "sunny_test.png")
        multiInfoView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMM yyyy" // Formatage français de la date
        dateLabl.text = formatter.string(from: dateAjd).capitalized
    }
    
    
    /**
     Récupère les données du webservice.
     */
    func getWsData(ville: String){
        let url : String = "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22"
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
    
    func getUVfromWS(){
        let url = "https://samples.openweathermap.org/data/2.5/uvi?lat=37.75&lon=-122.37&appid=0fe58b4b34de9e8260b69024f643a82a"
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
        let weatherArray = data["weather"] as! [[String: AnyObject]]
        let weather = weatherArray[0]
        self.weatherIconId = weather["id"] as! NSNumber
        let min : NSNumber = main["temp_min"] as! NSNumber
        let max : NSNumber = main["temp_max"] as! NSNumber
        let humidity : NSNumber = main["humidity"] as! NSNumber
        let windSpeed : NSNumber = windData["speed"] as! NSNumber
        let windDirection : NSNumber = windData["deg"] as! NSNumber
        
        villeLabel.text = (data["name"] as! String).capitalized
        tempLabel.text = String((main["temp"] as! NSNumber).intValue) + "°C"
        minMaxLabel.text = String(min.intValue) + "°C /" + String(max.intValue) + "°C"
        humidityLabel.text = "Humidité \n" + String(humidity.intValue) + "%"
        windDirectionLabel.text = "Dir-Vent \n" + String(windDirection.intValue)
        windSpeedLabel.text = "Vitesse \n" + String(windSpeed.intValue) + " km/h"
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
