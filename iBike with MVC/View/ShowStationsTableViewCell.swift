//
//  ShowStationsTableViewCell.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/27.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit

class ShowStationsTableViewCell: UITableViewCell {

    @IBOutlet weak var stationsNameButton: UIButton!
    @IBOutlet weak var availableImageView: UIImageView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
