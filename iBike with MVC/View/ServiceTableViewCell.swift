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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
