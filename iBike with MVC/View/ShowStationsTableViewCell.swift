//
//  ShowStationsTableViewCell.swift
//  iBike with MVC
//
//  Created by CS01196 on 2020/5/27.
//  Copyright © 2020 CS01196. All rights reserved.
//

import UIKit

protocol ShowStationsCellDelegate {
    func tapButton(data: ALLiBike)
}

class ShowStationsTableViewCell: UITableViewCell {

    @IBOutlet weak var stationsNameButton: UIButton!
    @IBOutlet weak var availableImageView: UIImageView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private var buttonDelegate: ShowStationsCellDelegate?
    private var alliBike: ALLiBike?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func didTapStationsButton(_ sender: UIButton) {
        
        guard let iBikeData = self.alliBike else { return }
        /*透過buttonDelegate去執行protocol的function，傳iBikeData給delegate*/
        buttonDelegate?.tapButton(data: iBikeData)
        
        let buttonTitle = sender.title(for: .normal)
        print(buttonTitle!)
        
    }
    
    func configCell(_ data: ALLiBike, delegate: ShowStationsCellDelegate) {
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
