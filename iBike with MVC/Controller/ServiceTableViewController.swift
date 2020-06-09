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
        return allStationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "serviceTableViewCell") as? ServiceTableViewCell else {return UITableViewCell()}
        
        cell.stationsLabel.text = allStationsArray[indexPath.row].Position!
        cell.addressLabel.text = allStationsArray[indexPath.row].CAddress!
        cell.availableLavel.text = "可借車輛：\(String((allStationsArray[indexPath.row].AvailableCNT)!))"
        cell.updateLabel.text = "更新時間：\(allStationsArray[indexPath.row].UpdateTime!)"
 
        return cell
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        self.navigationController?.popViewController(animated: true)
        
    }
    


}
