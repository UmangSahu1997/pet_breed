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

    @IBOutlet weak var breedLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var petImgView: UIImageView!
    @IBAction func likeBtn(_ sender: UIButton) {
        likeDelegate?.likeBtnTap(for: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
