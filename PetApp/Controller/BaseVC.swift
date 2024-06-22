//
//  BaseVC.swift
//  PetApp
//
//  Created by Umang Sahu on 22/06/24.
//

import UIKit

class LikedModel: Codable {
    let imgURL: [String]?
    let breed: String?

    init(imgURL: [String]?, breed: String?) {
        self.imgURL = imgURL
        self.breed = breed
    }
}

class BaseVC: UIViewController {

    let userDefaults = UserDefaults.standard
    var likedPetList: LikedModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(likedPetList)
    }
    
    func addFavList(kk: LikedModel) {
        likedPetList = kk
        print("dd")
    }
}
