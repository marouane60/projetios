//
//  DetailsViewController.swift
//  projet
//
//  Created by tp on 15/03/2019.
//  Copyright © 2019 projet. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var villeRequete: String!;
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var map: MKMapView!;
    var slides:[Slide] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self;
        slides = getWsData(ville: villeRequete)
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)

        
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
    
    // Regle l affichage des slides
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    // Appelle le WS pour avoir l image de la ville et retourne les sliders
    func getWsData(ville: String)-> [Slide]{
        print(ville)
        let url : String =  "https://api.teleport.org/api/urban_areas/slug:"+ville+"/images/"
        var rep : [String : Any] = [String : Any]()
        var slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        var slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        Alamofire.request(url).responseJSON{ (reponse) in
            
            if(reponse.result.isSuccess){
                rep = (reponse.result.value! as? [String : Any])!
                let main : [[String:Any]]  = rep["photos"] as! [[String:Any]]
                let images = main[0]["image"] as! [String : AnyObject]
                let firstImg = images["mobile"] as! String;

                let firstUrl = URL(string: firstImg)

                let firstImgResponse = try? Data(contentsOf: firstUrl!);
                
                //Création des slides
                slide1.imageView.image = UIImage(data: firstImgResponse!)
                slide2.imageView.image = UIImage(named: "newYork0.jpg")
                
            }else{
                print("Erreur : \(reponse.result.error!)")
            }
        }
        
        return [slide1, slide2];
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
