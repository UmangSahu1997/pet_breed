//
//  PerticularBreedModel.swift
//  PetApp
//
//  Created by Umang Sahu on 23/06/24.
//

import Foundation
class PerticularBreedList: Codable {
    let message: [String]?
    let status: String?

    init(message: [String]?, status: String?) {
        self.message = message
        self.status = status
    }
}
