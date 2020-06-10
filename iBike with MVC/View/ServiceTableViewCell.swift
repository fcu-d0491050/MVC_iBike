//
//  ServiceTableViewCell.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/28.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stationsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var availableLavel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    private var alliBike: ALLiBike?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(_ data: ALLiBike) {
        self.alliBike = data
        self.stationsLabel.text = data.Position!
        self.addressLabel.text = data.CAddress!
        self.availableLavel.text = "可借車輛：\(String((data.AvailableCNT)!))"
        self.updateLabel.text = "更新時間：\(data.UpdateTime!)"
        
    }
    
}
