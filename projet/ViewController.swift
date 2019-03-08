//
//  ViewController.swift
//  projet
//
//  Created by tp on 08/03/2019.
//  Copyright © 2019 projet. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var maxTemp: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request("https://httpbin.org/get").validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
            }
        }
        
        struct Weather: Codable {
            var name: String
            var points: Int
            var description: String?
        }
        
        let json = """
{
    "name": "Durian",
    "points": 600,
    "description": "A fruit with a distinctive scent."
}
""".data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let product = try! decoder.decode(Weather.self, from: json)
        
        print(product.name) // Prints "Durian"
    }


}

