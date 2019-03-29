//
//  SearchViewController.swift
//
//
//  Created by tp on 22/03/2019.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {
    static var citiesCapitals = ["Abu Dhabi", "Abuja", "Adamstown", "Addis Ababa", "Algiers", "Alofi", "Amman", "Amsterdam", "Andorra la Vella", "Ankara", "Antananarivo", "Apia", "Ashgabat", "Asmara", "Astana", "Asuncion", "Atafu", "Athens", "Avarua", "Baghdad", "Baku", "Bamako", "Bandar Seri Begawan", "Bangkok", "Bangui", "Banjul", "Basseterre", "Beijing", "Beirut", "Belgrade", "Belmopan", "Berlin", "Bern", "Bishkek", "Bissau", "Bogota", "Brasilia", "Bratislava", "Brazzaville", "Bridgetown", "Brussels", "Bucharest", "Budapest", "Buenos Aires", "Bujumbura", "Cairo", "Canberra", "Caracas", "Castries", "Charlotte Amalie", "Chisinau", "Colombo", "Conakry", "Copenhagen", "Dakar", "Damascus", "Dar es Salaam", "Dhaka", "Diego Garcia", "Dili", "Djibouti", "Doha", "Douglas", "Dublin", "Dushanbe", "Freetown", "Funafuti", "Gaborone", "George Town", "Georgetown", "Gibraltar", "Grand Turk", "Guatemala City", "Gustavia", "Hagatna", "Hamilton", "Hanoi", "Harare", "Hargeisa", "Havana", "Helsinki", "Honiara", "Islamabad", "Jakarta", "Jamestown", "Jerusalem", "Jerusalem", "Juba", "Kabul", "Kampala", "Kathmandu", "Khartoum", "Kigali", "King Edward Point", "Kingston", "Kingston", "Kingstown", "Kinshasa", "Kuala Lumpur", "Kuwait City", "Kyiv", "La Paz", "Libreville", "Lilongwe", "Lima", "Lisbon", "Ljubljana", "Lome", "London", "Longyearbyen", "Luanda", "Lusaka", "Luxembourg", "Madrid", "Majuro", "Malabo", "Male", "Managua", "Manama", "Manila", "Maputo", "Mariehamn", "Marigot", "Maseru", "Mata-Utu", "Mbabane", "Melekeok", "Mexico City", "Minsk", "Mogadishu", "Monaco", "Monrovia", "Montevideo", "Moroni", "Moscow", "Muscat", "N\'Djamena", "Nairobi", "Nassau", "New Delhi", "Niamey", "Nicosia", "North Nicosia", "Nouakchott", "Noumea", "Nuku\'alofa", "Nuuk", "Oranjestad", "Oslo", "Ottawa", "Ouagadougou", "Pago Pago", "Palikir", "Panama City", "Papeete", "Paramaribo", "Paris", "Philipsburg", "Phnom Penh", "Plymouth", "Podgorica", "Port Louis", "Port Moresby", "Port of Spain", "Port-Vila", "Port-au-Prince", "Port-aux-FranÃ§ais", "Porto-Novo", "Prague", "Praia", "Pretoria", "Pristina", "Pyongyang", "Quito", "Rabat", "Rangoon", "Reykjavik", "Riga", "Riyadh", "Road Town", "Rome", "Roseau", "Saint George\'s", "Saint Helier", "Saint John\'s", "Saint Peter Port", "Saint-Pierre", "Saipan", "San Jose", "San Juan", "San Marino", "San Salvador", "Sanaa", "Santiago", "Santo Domingo", "Sao Tome", "Sarajevo", "Seoul", "Singapore", "Skopje", "Sofia", "Stanley", "Stockholm", "Suva", "Taipei", "Tallinn", "Tarawa", "Tashkent", "Tbilisi", "Tegucigalpa", "Tehran", "The Settlement", "The Valley", "Thimphu", "Tirana", "Tokyo", "Torshavn", "Tripoli", "Tunis", "Ulaanbaatar", "Vaduz", "Valletta", "Vatican City", "Victoria", "Vienna", "Vientiane", "Vilnius", "Warsaw", "Washington", "Washington", "Wellington", "West Island", "Willemstad", "Windhoek", "Yamoussoukro", "Yaounde", "Yaren", "Yerevan", "Zagreb"]
    
    var searchedCountry = [String]()
    var searching = false
    
    //@IBOutlet weak var searchBar: UISearchBar!
    //@IBOutlet weak var resTableView: UITableView!
    @IBOutlet weak var resTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidAppear(_ animated: Bool) {
        SearchViewController.citiesCapitals.sort()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resTableView.delegate = self
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else {
            return SearchViewController.citiesCapitals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resCell")
        if searching {
            cell?.textLabel?.text = searchedCountry[indexPath.row]
        } else {
            cell?.textLabel?.text = SearchViewController.citiesCapitals[indexPath.row]
        }
        return cell!
    }
    
    //fonction de séléction d'un ville
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var villes = Array<String>()
        
        if(UserDefaults.standard.array(forKey: "villesChoisies") != nil){
            villes = UserDefaults.standard.array(forKey: "villesChoisies") as! Array<String>
        }
        
        villes.append(searchedCountry[indexPath.row]) //On ajoute la ville séléctionnée dans le popup
        villes.sort()
        UserDefaults.standard.set(villes, forKey:"villesChoisies") //On sauvegarde dans la mémoire du tel le choix effectué
        
        ViewController.villes = UserDefaults.standard.object(forKey: "villesChoisies") as! Array<String>
        SearchViewController.citiesCapitals.removeAll { (item) -> Bool in
            item == searchedCountry[indexPath.row];
        } //On met à jour la liste des villes proposées pour ne pas ajouter plusieurs fois la même ville
        SearchViewController.citiesCapitals.sort()
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = SearchViewController.citiesCapitals.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        resTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        resTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}
