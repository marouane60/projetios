//
//  DetailsViewController.swift
//  projet
//
//  Created by tp on 15/03/2019.
//  Copyright © 2019 projet. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    var villeRequete: String!;
        
    @IBOutlet weak var map: MKMapView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(villeRequete != nil){
            
            // Recherche et affichage de la ville selectionnée
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(villeRequete) { (placemarks:[CLPlacemark]?, error:Error?) in
                if error == nil {
                    
                    let placemark = placemarks?.first
                    
                    let anno = MKPointAnnotation()
                    anno.coordinate = (placemark?.location?.coordinate)!;
                    anno.title = self.villeRequete;
                    
                    let span = MKCoordinateSpan.init(latitudeDelta:0.075,longitudeDelta:0.075);
                    let region = MKCoordinateRegion(center: anno.coordinate, span: span);
                    
                    self.map.setRegion(region, animated: true)
                    self.map.addAnnotation(anno)
                    self.map.selectAnnotation(anno, animated: true)
                    
                }else{
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
