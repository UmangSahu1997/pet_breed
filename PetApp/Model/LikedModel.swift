//
//  LikedModel.swift
//  PetApp
//
//  Created by Umang Sahu on 23/06/24.
//

import Foundation

class LikedModel: Codable {
    let imgURL: [String]?
    let breed: String?

    init(imgURL: [String]?, breed: String?) {
        self.imgURL = imgURL
        self.breed = breed
    }
}
