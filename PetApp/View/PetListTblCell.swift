//
//  PetListTblCell.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

class PetListTblCell: UITableViewCell {
    
    @IBOutlet weak var breedLbl: UILabel!
    
    @IBOutlet weak var parentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.uiSetup()
    }
    
    private func uiSetup(){
        parentView.layer.cornerRadius = 4
        parentView.layer.shadowColor = UIColor.gray.cgColor
        parentView.layer.shadowOpacity = 0.2
        parentView.layer.shadowOffset = .zero
        parentView.layer.shadowRadius = 5
    }
    
    func bindCell(data: String) {
        breedLbl.text = data
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
