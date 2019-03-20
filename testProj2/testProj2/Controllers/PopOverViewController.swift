import UIKit

class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Popupview: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    static var names: [String] = ["Mumbai","New York","Tokyo","London","Beijing","Sydney","Wellington","Madrid","Rome","Cape Town","Ottawa"]
    
    //Reste à faire: récupérer une vraie liste des villes
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero) //permet d'enlever les lignes vides du tableView
        tableView.layer.cornerRadius = 10
        
        Popupview.layer.masksToBounds = true
        Popupview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData() //On recharge la tableView
    }
    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PopOverViewController.names.count;
    }
    
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var villes = UserDefaults.standard.array(forKey: "villesChoisies") as! Array<String>
        villes.append(PopOverViewController.names[indexPath.row]) //On ajoute la ville séléctionnée dans le popup
        villes.sort()
        UserDefaults.standard.set(villes, forKey:"villesChoisies") //On sauvegarde dans la mémoire du tel le choix effectué
        
        ViewController.villes = UserDefaults.standard.object(forKey: "villesChoisies") as! Array<String>
        PopOverViewController.names.remove(at: indexPath.row) //On met à jour la liste des villes proposées pour ne pas ajouter plusieurs fois la même ville
        PopOverViewController.names.sort()
        dismiss(animated: true, completion: nil)
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = PopOverViewController.names[indexPath.row]
        //cell.textLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return cell
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
