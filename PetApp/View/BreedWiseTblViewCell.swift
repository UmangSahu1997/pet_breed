//
//  BreedWiseTblViewCell.swift
//  PetApp
//
//  Created by Umang Sahu on 21/06/24.
//

import UIKit

protocol TodoDelegate: AnyObject {
    func likeBtnTap(for cell: BreedWiseTblViewCell)
}

class BreedWiseTblViewCell: UITableViewCell {
    
    weak var likeDelegate: TodoDelegate?
    var indexPath: IndexPath?

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var breedLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var petImgView: UIImageView!
    @IBAction func likeBtn(_ sender: UIButton) {
        likeDelegate?.likeBtnTap(for: self)
    }
    
    private func uiSetup() {
        parentView.layer.cornerRadius = 4
        parentView.layer.shadowColor = UIColor.gray.cgColor
        parentView.layer.shadowOpacity = 0.2
        parentView.layer.shadowOffset = .zero
        parentView.layer.shadowRadius = 5
        
        breedLbl.text = ""
        petImgView.layer.cornerRadius = 4
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(systemName: "search", withConfiguration: boldConfig)

        likeBtn.setImage(boldSearch, for: .normal)
        //likeBtn.setImage(UIImage(named: "heart"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
