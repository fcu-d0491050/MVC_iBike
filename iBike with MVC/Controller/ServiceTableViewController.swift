//
//  ServiceTableViewController.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/28.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit

class ServiceTableViewController: UITableViewController {

    @IBOutlet var serviceTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let allStationsArray = API.shared.stations
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.shared.stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "serviceTableViewCell") as? ServiceTableViewCell {
            
            let data: ALLiBike? = API.shared.stations[indexPath.row]
            
            if let iBikeData = data {
                cell.configCell(iBikeData)
            }
 
            return cell
            
        }
        return UITableViewCell()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
        
    }
    


}
