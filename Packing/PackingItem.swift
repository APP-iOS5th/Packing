//
//  Luggage.swift
//  Packing
//
//  Created by 김영훈 on 5/1/24.
//

import Foundation

class ShareLuggage: Codable {
    
    let name: String
    var checkedPeople: [String]
    var requiredCount: Int
    
    init(name: String, checkedPeople: [String], requiredCount: Int) {
        self.name = name
        self.checkedPeople = checkedPeople
        self.requiredCount = requiredCount
    }
}

class PersonalLuggage: Codable {

    let name: String
    var isChecked: Bool
    
    init(name: String, isChecked: Bool) {
        self.name = name
        self.isChecked = isChecked
    }
}

class PackingItem: Codable {
    let id: String
    let personal: [String: [PersonalLuggage]]
    let share: [ShareLuggage]
    
    init(id: String, personal: [String : [PersonalLuggage]], share: [ShareLuggage]) {
        self.id = id
        self.personal = personal
        self.share = share
    }
}
