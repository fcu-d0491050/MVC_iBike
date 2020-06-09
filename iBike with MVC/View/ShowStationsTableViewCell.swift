//
//  ShowStationsTableViewCell.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/27.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit

protocol ButtonDelegate {
    func tapButton(_ data: ALLiBike)
}

class ShowStationsTableViewCell: UITableViewCell {

    @IBOutlet weak var stationsNameButton: UIButton!
    @IBOutlet weak var availableImageView: UIImageView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private var buttonDelegate: ButtonDelegate?
    private var alliBike: ALLiBike?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapStationsButton(_ sender: UIButton) {
        
        guard let data = self.alliBike else { return }
        buttonDelegate?.tapButton(data)
        
        let buttonTitle = sender.title(for: .normal)
        print(buttonTitle!)
        
    }
    
    func configCell(_ data: ALLiBike, delegate: ButtonDelegate) {
        self.buttonDelegate = delegate
        self.alliBike = data
        self.stationsNameButton.contentHorizontalAlignment = .leading
        self.stationsNameButton.setTitle(data.Position!, for: .normal)
        self.availableImageView.image = UIImage(named: "availableImage")
        self.availableLabel.text = String((data.AvailableCNT!))
        self.emptyImageView.image = UIImage(named: "emptyImage")
        self.emptyLabel.text = String((data.EmpCNT!))
        self.addressLabel.text = String((data.CAddress!))
    }

}
