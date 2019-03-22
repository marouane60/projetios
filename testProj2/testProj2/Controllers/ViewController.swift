
import UIKit
import Alamofire


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    static var villes: [String] = []
    //var weather : WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let bckgColor = UIColor(red: 9/255.0, green: 0/255.0, blue: 114/255.0, alpha: 1.0)
        
        UserDefaults.standard.set([String](), forKey:"villesChoisies")
        
        btnSelect.backgroundColor = .clear
        btnSelect.layer.cornerRadius = 5
        btnSelect.layer.borderWidth = 0.5
        btnSelect.layer.borderColor = UIColor.lightGray.cgColor
        
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView(frame: .zero)
        mainTableView.backgroundColor = nil
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "newYork0.jpg")!)
        
        
        //mainTableView.backgroundColor = bckgColor;
        
        //self.weather = WeatherData()
                                                                        // il faudra qu'on mette la ville actuelle et notre apikey
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainTableView.reloadData() //On recharge la tableView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.villes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        cell.textLabel?.text = ViewController.villes[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ViewController.villes.remove(at: indexPath.row) //On supprime la vile de la liste des favoris
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailsViewController
        {
            let vc = segue.destination as? DetailsViewController
            vc?.villeRequete = "toronto"
        }
    }
}
