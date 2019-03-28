
import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    static var villes: Array<String> = Array<String>()
    
    var villeRequete: String!;
    
    var aide: Bool!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aide = false;
        mainTableView.delegate = self
        mainTableView.dataSource = self

        
        if(isKeyPresentInUserDefaults(key: "villesChoisies")){
            ViewController.villes = (UserDefaults.standard.array(forKey: "villesChoisies") as! Array<String>)
        }
        print(ViewController.villes)
        btnSelect.backgroundColor = .clear
        
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView(frame: .zero)
        mainTableView.backgroundColor = nil
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newYork0.jpg")!)
        
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainTableView.reloadData() //On recharge la tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.villes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        cell.accessoryType = .detailDisclosureButton
        cell.textLabel?.text = ViewController.villes[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        aide = true;
        let currentCell = tableView.cellForRow(at:indexPath)! as UITableViewCell
        currentCell.selectionStyle = .none
        self.villeRequete = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "detailSegue", sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            SearchViewController.citiesCapitals.append(ViewController.villes[indexPath.row]) //On réinsère la ville supprimée dans la liste des villes du popup
            SearchViewController.citiesCapitals.sort()
            //On suprime le favoris de la mémoire du tel:
            var favs = UserDefaults.standard.object(forKey: "villesChoisies") as! Array<String>
            favs.remove(at: indexPath.row)
            UserDefaults.standard.set(favs, forKey:"villesChoisies") //mise à jour
            
            tableView.reloadData()
        }
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        if (aide == false){
            let indexPath = tableView.indexPathForSelectedRow!
            let currentCell = tableView.cellForRow(at:indexPath)! as UITableViewCell
            
            tableView.deselectRow(at: indexPath, animated: true)
            self.villeRequete = tableView.cellForRow(at: indexPath)?.textLabel?.text
            
            performSegue(withIdentifier: "segue", sender: indexPath)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is HomeViewController
        {
            let vc = segue.destination as? HomeViewController
            vc?.villeParam = self.villeRequete
        }
        
        if segue.destination is DetailsViewController
        {
            let vc = segue.destination as? DetailsViewController
            vc?.villeRequete = self.villeRequete
        }
    }
}




