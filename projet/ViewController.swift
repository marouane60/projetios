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

class ViewController: UIViewController {
    
    @IBOutlet weak var maxTemp: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?id=2989317&APPID=0fe58b4b34de9e8260b69024f643a82a").validate().responseJSON { response in
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

